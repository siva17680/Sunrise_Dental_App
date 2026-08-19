package com.sunrise.chain;

public class PatientCheck extends BookingValidator {
    @Override
    public boolean check(int patientId, String date, String time) throws Exception {
        if (patientId <= 0) {
            throw new Exception("Invalid Patient ID");
        }
        return checkNext(patientId, date, time);
    }
}
