package com.example.main;

import com.example.api.Logger;
import org.springframework.core.io.support.SpringFactoriesLoader;

import java.util.List;

/**
 * 主應用程式 - 使用 Spring Factories 機制載入 Logger 實作
 */
public class Main {
    public static void main(String[] args) {
        // 使用 SpringFactoriesLoader 載入所有 Logger 實作
        List<Logger> loggers = SpringFactoriesLoader.loadFactories(
            Logger.class, 
            Main.class.getClassLoader()
        );
        
        Logger bestLogger = null;
        int maxPriority = 0;
        
        System.out.println("Available loggers (via Spring Factories):");
        for (Logger logger : loggers) {
            System.out.println("- " + logger.getName() + " (priority: " + logger.getPriority() + ")");
            if (logger.getPriority() > maxPriority) {
                maxPriority = logger.getPriority();
                bestLogger = logger;
            }
        }
        
        if (bestLogger != null) {
            System.out.println("\nSelected: " + bestLogger.getName());
            bestLogger.log("Hello from Spring Factories!");
        } else {
            System.out.println("No logger implementations found!");
        }
    }
}
