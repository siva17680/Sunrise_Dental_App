package com.sunrise.servlet;

import com.sunrise.model.User;
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

@WebServlet("/pharmacistProcess")
public class PharmacistProcessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"PHARMACIST".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String presIdStr = request.getParameter("id");
        if (presIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/pharmacistDashboard");
            return;
        }

        int presId = Integer.parseInt(presIdStr);
        Map<String, Object> prescriptionInfo = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Get Prescription Details
            String sql = "SELECT p.id as pres_id, i.invoice_id, COALESCE(u.name, i.guest_name, 'Guest') as patient_name, d.name as doctor_name, p.date_issued " +
                         "FROM prescriptions p " +
                         "JOIN invoices i ON p.invoice_id = i.invoice_id " +
                         "LEFT JOIN users u ON p.patient_id = u.id " +
                         "JOIN users d ON p.doctor_id = d.id " +
                         "WHERE p.id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, presId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                prescriptionInfo.put("pres_id", rs.getInt("pres_id"));
                prescriptionInfo.put("invoice_id", rs.getInt("invoice_id"));
                prescriptionInfo.put("patient", rs.getString("patient_name"));
                prescriptionInfo.put("doctor", rs.getString("doctor_name"));
                prescriptionInfo.put("date", rs.getTimestamp("date_issued"));

                // Get Items
                String itemSql = "SELECT id, medicine_name, dosage, quantity FROM prescription_items WHERE prescription_id = ?";
                PreparedStatement itemStmt = conn.prepareStatement(itemSql);
                itemStmt.setInt(1, presId);
                ResultSet itemRs = itemStmt.executeQuery();
                while (itemRs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("item_id", itemRs.getInt("id"));
                    item.put("name", itemRs.getString("medicine_name"));
                    item.put("dosage", itemRs.getString("dosage"));
                    item.put("quantity", itemRs.getInt("quantity"));
                    items.add(item);
                }

                request.setAttribute("prescription", prescriptionInfo);
                request.setAttribute("items", items);
                request.getRequestDispatcher("/process_prescription.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/pharmacistDashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"PHARMACIST".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String invoiceIdStr = request.getParameter("invoice_id");
        String[] itemIds = request.getParameterValues("item_id[]");
        String[] prices = request.getParameterValues("price[]");
        String[] quantities = request.getParameterValues("quantity[]");

        if (invoiceIdStr != null && itemIds != null && prices != null && quantities != null) {
            try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
                conn.setAutoCommit(false);
                try {
                    double additionalCost = 0.0;
                    
                    // Update prices for each item
                    String updateItemSql = "UPDATE prescription_items SET price = ? WHERE id = ?";
                    PreparedStatement itemStmt = conn.prepareStatement(updateItemSql);
                    
                    for (int i = 0; i < itemIds.length; i++) {
                        double price = Double.parseDouble(prices[i]);
                        int qty = Integer.parseInt(quantities[i]);
                        int itemId = Integer.parseInt(itemIds[i]);
                        
                        itemStmt.setDouble(1, price);
                        itemStmt.setInt(2, itemId);
                        itemStmt.addBatch();
                        
                        additionalCost += (price * qty);
                    }
                    itemStmt.executeBatch();

                    // Update total invoice amount
                    if (additionalCost > 0) {
                        String updateInvSql = "UPDATE invoices SET total_amount = total_amount + ? WHERE invoice_id = ?";
                        PreparedStatement invStmt = conn.prepareStatement(updateInvSql);
                        invStmt.setDouble(1, additionalCost);
                        invStmt.setInt(2, Integer.parseInt(invoiceIdStr));
                        invStmt.executeUpdate();
                    }

                    conn.commit();
                    
                    // Redirect directly to the printed bill!
                    response.sendRedirect(request.getContextPath() + "/printBill?id=" + invoiceIdStr);
                    return;
                } catch (Exception e) {
                    conn.rollback();
                    e.printStackTrace();
                } finally {
                    conn.setAutoCommit(true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/pharmacistDashboard");
    }
}
