package com.sunrise.chain;

import java.time.LocalTime;

public class TimeSlotCheck extends BookingValidator {
    @Override
    public boolean check(int patientId, String date, String time) throws Exception {
        if (time == null || time.isEmpty()) {
            throw new Exception("Time slot must be provided.");
        }
        
        LocalTime requestedTime = LocalTime.parse(time);
        LocalTime clinicOpen = LocalTime.of(8, 0); // 8 AM
        LocalTime clinicClose = LocalTime.of(20, 0); // 8 PM
        
        if (requestedTime.isBefore(clinicOpen) || requestedTime.isAfter(clinicClose)) {
            throw new Exception("Time slot is outside of clinic operating hours.");
        }
        
        return checkNext(patientId, date, time);
    }
}
