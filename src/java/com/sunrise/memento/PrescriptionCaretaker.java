package com.sunrise.memento;

import jakarta.servlet.http.HttpSession;

public class PrescriptionCaretaker {
    private static final String MEMENTO_SESSION_KEY = "savedPrescriptionDraft";

    public void saveMemento(HttpSession session, PrescriptionMemento memento) {
        session.setAttribute(MEMENTO_SESSION_KEY, memento);
    }

    public PrescriptionMemento getMemento(HttpSession session) {
        return (PrescriptionMemento) session.getAttribute(MEMENTO_SESSION_KEY);
    }
}
