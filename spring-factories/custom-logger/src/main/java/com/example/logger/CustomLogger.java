package com.example.logger;

import com.example.api.Logger;

/**
 * CustomLogger 實作 - 基礎 Logger，優先級為 100
 */
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
