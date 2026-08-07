package com.sunrise.servlet;

import com.sunrise.util.DatabaseConnectionManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/adminBilling")
public class AdminBillingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.sunrise.model.User user = (com.sunrise.model.User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> bills = new ArrayList<>();
        List<Map<String, Object>> services = new ArrayList<>();
        List<Map<String, Object>> doctors = new ArrayList<>();

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Load bills with Doctor Name (either from appointment or direct guest assignment)
            String sql = "SELECT i.invoice_id, i.total_amount, i.status, i.issue_date, i.guest_name, p.name as patient_name, " +
                         "COALESCE(d_appt.name, d_guest.name) as doctor_name " +
                         "FROM invoices i " +
                         "LEFT JOIN users p ON i.patient_id = p.id " +
                         "LEFT JOIN appointments a ON i.appointment_id = a.id " +
                         "LEFT JOIN users d_appt ON a.doctor_id = d_appt.id " +
                         "LEFT JOIN users d_guest ON i.doctor_id = d_guest.id " +
                         "ORDER BY i.issue_date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("id", rs.getInt("invoice_id"));
                bill.put("amount", rs.getDouble("total_amount"));
                bill.put("status", rs.getString("status"));
                bill.put("date", rs.getTimestamp("issue_date"));
                
                String pName = rs.getString("patient_name");
                String gName = rs.getString("guest_name");
                bill.put("patient", pName != null ? pName : (gName != null ? gName + " (Guest)" : "Unknown"));
                
                String dName = rs.getString("doctor_name");
                bill.put("doctor", dName != null ? dName : "Unassigned");
                
                bills.add(bill);
            }

            // Load services
            String svcSql = "SELECT * FROM services";
            PreparedStatement svcStmt = conn.prepareStatement(svcSql);
            ResultSet svcRs = svcStmt.executeQuery();
            while (svcRs.next()) {
                Map<String, Object> s = new HashMap<>();
                s.put("id", svcRs.getInt("id"));
                s.put("name", svcRs.getString("name"));
                s.put("cost", svcRs.getDouble("cost"));
                services.add(s);
            }
            
            // Load doctors
            String docSql = "SELECT id, name FROM users WHERE role = 'DOCTOR'";
            PreparedStatement docStmt = conn.prepareStatement(docSql);
            ResultSet docRs = docStmt.executeQuery();
            while (docRs.next()) {
                Map<String, Object> d = new HashMap<>();
                d.put("id", docRs.getInt("id"));
                d.put("name", docRs.getString("name"));
                doctors.add(d);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Database error loading bills");
        }
        
        request.setAttribute("bills", bills);
        request.setAttribute("services", services);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/admin_billing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            if ("mark_paid".equals(action)) {
                String idStr = request.getParameter("invoice_id");
                if (idStr != null) {
                    String updateSql = "UPDATE invoices SET status = 'PAID' WHERE invoice_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(updateSql);
                    stmt.setInt(1, Integer.parseInt(idStr));
                    stmt.executeUpdate();
                }
            } else {
                // Generate manual bill
                String guestName = request.getParameter("guest_name");
                String guestContact = request.getParameter("guest_contact");
                String guestAgeStr = request.getParameter("guest_age");
                String guestAddress = request.getParameter("guest_address");
                String doctorIdStr = request.getParameter("doctor_id");
                String[] serviceIds = request.getParameterValues("services");
        
                double totalCost = 0.0;
                int guestAge = (guestAgeStr != null && !guestAgeStr.isEmpty()) ? Integer.parseInt(guestAgeStr) : 0;
                int doctorId = (doctorIdStr != null && !doctorIdStr.isEmpty()) ? Integer.parseInt(doctorIdStr) : 0;
                
                if (serviceIds != null && serviceIds.length > 0) {
                    for (String svcId : serviceIds) {
                        PreparedStatement getCost = conn.prepareStatement("SELECT cost FROM services WHERE id = ?");
                        getCost.setInt(1, Integer.parseInt(svcId));
                        ResultSet rs = getCost.executeQuery();
                        if (rs.next()) totalCost += rs.getDouble("cost");
                    }
                }
        
                String insertSql = "INSERT INTO invoices (patient_id, guest_name, guest_contact, guest_age, guest_address, doctor_id, total_amount, status) VALUES (NULL, ?, ?, ?, ?, ?, ?, 'UNPAID')";
                PreparedStatement stmt = conn.prepareStatement(insertSql);
                stmt.setString(1, guestName);
                stmt.setString(2, guestContact);
                stmt.setInt(3, guestAge);
                stmt.setString(4, guestAddress);
                
                if(doctorId > 0) stmt.setInt(5, doctorId);
                else stmt.setNull(5, java.sql.Types.INTEGER);
                
                stmt.setDouble(6, totalCost);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/adminBilling");
    }
}
