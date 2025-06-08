package com.example.api;

/**
 * Logger 介面 - 用於 Spring Factories 機制
 */
public interface Logger {
    
    /**
     * 記錄訊息
     * @param message 要記錄的訊息
     */
    void log(String message);
    
    /**
     * 取得 logger 名稱
     * @return logger 名稱
     */
    String getName();
    
    /**
     * 取得 logger 優先級（數值越高越優先）
     * @return 優先級
     */
    int getPriority();
}
