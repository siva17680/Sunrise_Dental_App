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
import java.sql.Statement;

@WebServlet("/doctorPrescribe")
public class DoctorPrescribeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
            String apptIdStr = request.getParameter("appt_id");
        String invoiceIdStr = request.getParameter("invoice_id");
        
        if (apptIdStr == null && invoiceIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/doctorDashboard");
            return;
        }
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            if (apptIdStr != null) {
                // Registered Patient via Appointment
                String sql = "SELECT a.patient_id, u.name as patient_name " +
                             "FROM appointments a " +
                             "JOIN users u ON a.patient_id = u.id " +
                             "WHERE a.id = ? AND a.doctor_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(apptIdStr));
                stmt.setInt(2, user.getId());
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("appt_id", apptIdStr);
                    request.setAttribute("patient_id", rs.getInt("patient_id"));
                    request.setAttribute("patient_name", rs.getString("patient_name"));
                    request.getRequestDispatcher("/prescribe.jsp").forward(request, response);
                    return;
                }
            } else if (invoiceIdStr != null) {
                // Guest Walk-in via Invoice
                String sql = "SELECT guest_name " +
                             "FROM invoices " +
                             "WHERE invoice_id = ? AND doctor_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(invoiceIdStr));
                stmt.setInt(2, user.getId());
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("invoice_id", invoiceIdStr);
                    request.setAttribute("patient_id", -1); // No registered patient ID for guests
                    request.setAttribute("patient_name", rs.getString("guest_name") + " (Guest)");
                    request.getRequestDispatcher("/prescribe.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/doctorDashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String apptIdStr = request.getParameter("appt_id");
        String invoiceIdStr = request.getParameter("invoice_id");
        int patientId = Integer.parseInt(request.getParameter("patient_id"));
        
        String[] medicines = request.getParameterValues("medicine_name[]");
        String[] dosages = request.getParameterValues("dosage[]");
        String[] quantities = request.getParameterValues("quantity[]");
        String action = request.getParameter("action"); // e.g. 'draft' or 'submit'

        if ("draft".equals(action)) {
            // Memento Pattern: Save draft
            com.sunrise.memento.PrescriptionMemento memento = new com.sunrise.memento.PrescriptionMemento(medicines, dosages, quantities);
            com.sunrise.memento.PrescriptionCaretaker caretaker = new com.sunrise.memento.PrescriptionCaretaker();
            caretaker.saveMemento(request.getSession(), memento);
            response.sendRedirect(request.getContextPath() + "/doctorDashboard?msg=draft_saved");
            return;
        }

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int targetInvoiceId = -1;
                
                // 1. Create a NEW dedicated invoice for Pharmacy
                if (invoiceIdStr != null && !invoiceIdStr.isEmpty()) {
                    // It's a guest! Copy guest details from the original Admin invoice
                    int originalInvoiceId = Integer.parseInt(invoiceIdStr);
                    String copySql = "SELECT guest_name, guest_contact, guest_age, guest_address FROM invoices WHERE invoice_id = ?";
                    PreparedStatement copyStmt = conn.prepareStatement(copySql);
                    copyStmt.setInt(1, originalInvoiceId);
                    ResultSet copyRs = copyStmt.executeQuery();
                    
                    if (copyRs.next()) {
                        String insertInv = "INSERT INTO invoices (guest_name, guest_contact, guest_age, guest_address, doctor_id, total_amount, status) VALUES (?, ?, ?, ?, ?, 0.00, 'UNPAID')";
                        PreparedStatement insInvStmt = conn.prepareStatement(insertInv, Statement.RETURN_GENERATED_KEYS);
                        insInvStmt.setString(1, copyRs.getString("guest_name"));
                        insInvStmt.setString(2, copyRs.getString("guest_contact"));
                        insInvStmt.setInt(3, copyRs.getInt("guest_age"));
                        insInvStmt.setString(4, copyRs.getString("guest_address"));
                        insInvStmt.setInt(5, user.getId());
                        insInvStmt.executeUpdate();
                        
                        ResultSet keys = insInvStmt.getGeneratedKeys();
                        if (keys.next()) targetInvoiceId = keys.getInt(1);
                    }
                } else if (apptIdStr != null && !apptIdStr.isEmpty()) {
                    // It's a registered patient! Create new invoice linked to patient and appointment
                    int apptId = Integer.parseInt(apptIdStr);
                    String insertInv = "INSERT INTO invoices (patient_id, appointment_id, doctor_id, total_amount, status) VALUES (?, ?, ?, 0.00, 'UNPAID')";
                    PreparedStatement insInvStmt = conn.prepareStatement(insertInv, Statement.RETURN_GENERATED_KEYS);
                    insInvStmt.setInt(1, patientId);
                    insInvStmt.setInt(2, apptId);
                    insInvStmt.setInt(3, user.getId());
                    insInvStmt.executeUpdate();
                    
                    ResultSet generatedKeys = insInvStmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        targetInvoiceId = generatedKeys.getInt(1);
                    }
                }

                if (targetInvoiceId == -1) throw new Exception("Failed to generate Pharmacy Invoice.");

                // 2. Create Prescription
                int prescriptionId = -1;
                String insertPres = "INSERT INTO prescriptions (invoice_id, doctor_id, patient_id) VALUES (?, ?, ?)";
                PreparedStatement insPresStmt = conn.prepareStatement(insertPres, Statement.RETURN_GENERATED_KEYS);
                insPresStmt.setInt(1, targetInvoiceId);
                insPresStmt.setInt(2, user.getId());
                if(patientId > 0) insPresStmt.setInt(3, patientId);
                else insPresStmt.setNull(3, java.sql.Types.INTEGER); // Guest
                insPresStmt.executeUpdate();
                
                ResultSet presKeys = insPresStmt.getGeneratedKeys();
                if (presKeys.next()) {
                    prescriptionId = presKeys.getInt(1);
                }

                // 3. Add Prescription Items (price defaults to 0.00)
                if (medicines != null && prescriptionId != -1) {
                    String insertItem = "INSERT INTO prescription_items (prescription_id, medicine_name, dosage, quantity, price) VALUES (?, ?, ?, ?, 0.00)";
                    PreparedStatement insItemStmt = conn.prepareStatement(insertItem);
                    
                    for (int i = 0; i < medicines.length; i++) {
                        if (medicines[i].trim().isEmpty()) continue;
                        int itemQty = Integer.parseInt(quantities[i]);
                        
                        insItemStmt.setInt(1, prescriptionId);
                        insItemStmt.setString(2, medicines[i]);
                        insItemStmt.setString(3, dosages[i]);
                        insItemStmt.setInt(4, itemQty);
                        insItemStmt.addBatch();
                    }
                    insItemStmt.executeBatch();
                }
                
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/doctorDashboard?success=prescribed");
    }
}
