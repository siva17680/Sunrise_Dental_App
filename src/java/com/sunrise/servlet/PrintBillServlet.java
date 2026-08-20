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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/printBill")
public class PrintBillServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/adminBilling");
            return;
        }

        Map<String, Object> bill = new HashMap<>();
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            int invoiceId = Integer.parseInt(idStr);
            
            String sql = "SELECT i.invoice_id, i.appointment_id, i.total_amount, i.status, i.issue_date, i.guest_name, i.guest_contact, i.guest_age, p.name as patient_name, " +
                         "COALESCE(d_appt.name, d_guest.name) as doctor_name " +
                         "FROM invoices i " +
                         "LEFT JOIN users p ON i.patient_id = p.id " +
                         "LEFT JOIN appointments a ON i.appointment_id = a.id " +
                         "LEFT JOIN users d_appt ON a.doctor_id = d_appt.id " +
                         "LEFT JOIN users d_guest ON i.doctor_id = d_guest.id " +
                         "WHERE i.invoice_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                bill.put("id", rs.getInt("invoice_id"));
                bill.put("amount", rs.getDouble("total_amount"));
                bill.put("status", rs.getString("status"));
                bill.put("date", rs.getTimestamp("issue_date"));
                
                String dName = rs.getString("doctor_name");
                bill.put("doctor", dName != null ? dName : "Unassigned");
                
                String pName = rs.getString("patient_name");
                if (pName != null) {
                    bill.put("patient", pName);
                    bill.put("contact", "Registered User");
                    bill.put("age", "N/A");
                } else {
                    bill.put("patient", rs.getString("guest_name"));
                    bill.put("contact", rs.getString("guest_contact"));
                    bill.put("age", rs.getInt("guest_age"));
                }
                
                int appointmentId = rs.getInt("appointment_id"); // Could be 0/null
                
                // Fetch Services
                java.util.List<Map<String, Object>> services = new java.util.ArrayList<>();
                if (appointmentId > 0) {
                    String svcSql = "SELECT s.name, s.cost FROM appointment_services as_s JOIN services s ON as_s.service_id = s.id WHERE as_s.appointment_id = ?";
                    PreparedStatement svcStmt = conn.prepareStatement(svcSql);
                    svcStmt.setInt(1, appointmentId);
                    ResultSet svcRs = svcStmt.executeQuery();
                    while (svcRs.next()) {
                        Map<String, Object> svc = new HashMap<>();
                        svc.put("name", svcRs.getString("name"));
                        svc.put("cost", svcRs.getDouble("cost"));
                        services.add(svc);
                    }
                }
                request.setAttribute("services", services);

                // Fetch Medicines
                java.util.List<Map<String, Object>> medicines = new java.util.ArrayList<>();
                String medSql = "SELECT pi.medicine_name, pi.quantity, pi.price FROM prescription_items pi JOIN prescriptions pr ON pi.prescription_id = pr.id WHERE pr.invoice_id = ?";
                PreparedStatement medStmt = conn.prepareStatement(medSql);
                medStmt.setInt(1, invoiceId);
                ResultSet medRs = medStmt.executeQuery();
                while (medRs.next()) {
                    Map<String, Object> med = new HashMap<>();
                    med.put("name", medRs.getString("medicine_name") + " (x" + medRs.getInt("quantity") + ")");
                    med.put("cost", medRs.getDouble("price") * medRs.getInt("quantity"));
                    medicines.add(med);
                }
                request.setAttribute("medicines", medicines);

            } else {
                response.sendRedirect(request.getContextPath() + "/adminBilling");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminBilling?error=true");
            return;
        }
        
        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/print_bill.jsp").forward(request, response);
    }
}
