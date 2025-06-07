package com.example.logger;

import com.example.api.Logger;

public class CustomLogger implements Logger {
    @Override
    public void log(String message) {
        System.out.println("[CustomLogger] " + message);
    }

    @Override
    public String getName() {
        return "CustomLogger";
    }

    @Override
    public int getPriority() {
        return 100;
    }
}
