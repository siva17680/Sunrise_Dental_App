package com.sunrise.chain;

public abstract class BookingValidator {
    private BookingValidator next;

    public BookingValidator linkWith(BookingValidator next) {
        this.next = next;
        return next;
    }

    public abstract boolean check(int patientId, String date, String time) throws Exception;

    protected boolean checkNext(int patientId, String date, String time) throws Exception {
        if (next == null) {
            return true;
        }
        return next.check(patientId, date, time);
    }
}
