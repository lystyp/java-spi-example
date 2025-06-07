package com.example.main;

import com.example.api.Logger;
import java.util.ServiceLoader;

public class Main {
    public static void main(String[] args) {
        ServiceLoader<Logger> loader = ServiceLoader.load(Logger.class);
        
        Logger bestLogger = null;
        int maxPriority = 0;
        
        System.out.println("Available loggers:");
        for (Logger logger : loader) {
            System.out.println("- " + logger.getName() + " (priority: " + logger.getPriority() + ")");
            if (logger.getPriority() > maxPriority) {
                maxPriority = logger.getPriority();
                bestLogger = logger;
            }
        }
        
        if (bestLogger != null) {
            System.out.println("\nSelected: " + bestLogger.getName());
            bestLogger.log("Hello from SPI!");
        }
    }
}
