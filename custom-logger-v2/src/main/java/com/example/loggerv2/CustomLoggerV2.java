package com.example.loggerv2;

import com.example.api.Logger;

public class CustomLoggerV2 implements Logger {
    @Override
    public void log(String message) {
        System.out.println("[CustomLoggerV2] " + message);
    }

    @Override
    public String getName() {
        return "CustomLoggerV2";
    }

    @Override
    public int getPriority() {
        return 200;
    }
}
