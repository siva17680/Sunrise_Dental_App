package com.sunrise.memento;

import com.sunrise.models.Appointment;

/**
 * Memento Design Pattern - Stores the internal state of the Appointment object.
 */
public class AppointmentMemento {
    private final Appointment state;

    public AppointmentMemento(Appointment state) {
        this.state = state;
    }

    public Appointment getState() {
        return state;
    }
}
