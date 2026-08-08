package com.sunrise.memento;

import java.util.ArrayList;
import java.util.List;

/**
 * Caretaker class for Memento Design Pattern.
 */
public class AppointmentCaretaker {
    private List<AppointmentMemento> mementoList = new ArrayList<>();

    public void add(AppointmentMemento state) {
        mementoList.add(state);
    }

    public AppointmentMemento get(int index) {
        if (index >= 0 && index < mementoList.size()) {
            return mementoList.get(index);
        }
        return null;
    }
}
