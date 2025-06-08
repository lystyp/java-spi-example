package com.example.loggerv2;

import com.example.api.Logger;

/**
 * CustomLoggerV2 實作 - 進階 Logger，優先級為 200
 */
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
