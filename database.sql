CREATE DATABASE IF NOT EXISTS sunrisedental;
USE sunrisedental;

-- Table: users (Stores all user types)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DOCTOR', 'PATIENT', 'PHARMACIST') NOT NULL,
    name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20)
);

-- Table: patients (Extended details for patients)
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT PRIMARY KEY,
    dob DATE,
    age INT,
    address TEXT,
    medical_history TEXT,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: doctors (Extended details for doctors)
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT PRIMARY KEY,
    specialization VARCHAR(100),
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: services (Dynamic add-on services managed by Admin)
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50)
);

-- Table: doctor_availability
CREATE TABLE IF NOT EXISTS doctor_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

-- Table: appointments
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'COMPLETED', 'REJECTED') DEFAULT 'PENDING',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

-- Table: appointment_services (Links appointments to selected add-on services)
CREATE TABLE IF NOT EXISTS appointment_services (
    appointment_id INT NOT NULL,
    service_id INT NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Table: invoices (Auto-increment invoice_id, patient_id nullable for guests)
CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NULL,
    guest_name VARCHAR(100) NULL,
    guest_contact VARCHAR(20) NULL,
    guest_age INT NULL,
    guest_address TEXT NULL,
    appointment_id INT,
    doctor_id INT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('UNPAID', 'PAID') DEFAULT 'UNPAID',
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
);

-- Table: prescriptions
CREATE TABLE IF NOT EXISTS prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL, -- Links to auto-generated invoice
    doctor_id INT NOT NULL,
    patient_id INT NULL,
    date_issued TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

-- Table: prescription_items
CREATE TABLE IF NOT EXISTS prescription_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE
);

-- Sample Data Insertion
-- Users
INSERT IGNORE INTO users (id, username, password, role, name, contact_number) VALUES 
(1, 'admin', 'admin123', 'ADMIN', 'System Admin', '1234567890'),
(2, 'dr_smith', 'doc123', 'DOCTOR', 'Dr. John Smith', '9876543210'),
(3, 'dr_jones', 'doc123', 'DOCTOR', 'Dr. Alice Jones', '5551234567'),
(4, 'pharmacist', 'pharm123', 'PHARMACIST', 'Emma Watson', '1112223333'),
(5, 'john_doe', 'pat123', 'PATIENT', 'John Doe', '4445556666');

-- Doctors setup
INSERT IGNORE INTO doctors (doctor_id, specialization) VALUES 
(2, 'Orthodontist'),
(3, 'General Dentist');

-- Patients setup
INSERT IGNORE INTO patients (patient_id, dob, address, medical_history) VALUES 
(5, '1990-05-15', 'Colombo, Sri Lanka', 'No known allergies.');

-- Services (Add-ons)
INSERT IGNORE INTO services (id, name, description, cost, category) VALUES 
(1, 'General Consultation', 'Base consultation fee', 1500.00, 'Base'),
(2, 'Tooth Cleaning', 'Standard plaque removal and cleaning', 3500.00, 'Add-on'),
(3, 'Teeth Whitening', 'Cosmetic teeth whitening session', 12000.00, 'Add-on'),
(4, 'X-Ray', 'Dental panoramic x-ray', 2500.00, 'Add-on');

-- INSERT MOCK DATA FOR DOCTORS
INSERT IGNORE INTO users (id, name, username, password, role) VALUES 
(6, 'Dr. Emily Watson', 'doc_emily', 'pass123', 'DOCTOR'),
(7, 'Dr. James Miller', 'doc_james', 'pass123', 'DOCTOR'),
(8, 'Dr. Sarah Connor', 'doc_sarah', 'pass123', 'DOCTOR');

INSERT IGNORE INTO doctors (doctor_id, specialization) VALUES 
(6, 'Orthodontist'),
(7, 'Pediatric Dentist'),
(8, 'Oral Surgeon');

-- INSERT MOCK DOCTOR SCHEDULES (Dates set to a future arbitrary date for testing)
INSERT IGNORE INTO doctor_availability (doctor_id, available_date, start_time, end_time) VALUES 
(6, '2026-10-15', '09:00:00', '13:00:00'),
(6, '2026-10-16', '14:00:00', '18:00:00'),
(7, '2026-10-15', '10:00:00', '16:00:00'),
(8, '2026-10-17', '08:00:00', '12:00:00');
