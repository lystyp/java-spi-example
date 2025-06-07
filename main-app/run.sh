#!/bin/bash

# Java SPI Logger 執行腳本

echo "=== 執行 Java SPI Logger ==="

# 檢查是否在正確的目錄
if [ ! -f "../pom.xml" ]; then
    echo "錯誤: 請在 main-app 目錄中運行此腳本"
    exit 1
fi

# 檢查jar文件是否存在
if [ ! -f "target/main-app-1.0.jar" ]; then
    echo "錯誤: 找不到 main-app-1.0.jar，請先執行 mvn package"
    exit 1
fi

# 檢查依賴jar文件是否存在
if [ ! -f "../logger-api/target/logger-api-1.0.jar" ]; then
    echo "錯誤: 找不到 logger-api-1.0.jar，請先執行 mvn package"
    exit 1
fi

if [ ! -f "../custom-logger/target/custom-logger-1.0.jar" ]; then
    echo "錯誤: 找不到 custom-logger-1.0.jar，請先執行 mvn package"
    exit 1
fi

if [ ! -f "../custom-logger-v2/target/custom-logger-v2-1.0.jar" ]; then
    echo "錯誤: 找不到 custom-logger-v2-1.0.jar，請先執行 mvn package"
    exit 1
fi

# 設置classpath
CLASSPATH="target/main-app-1.0.jar:../logger-api/target/logger-api-1.0.jar:../custom-logger/target/custom-logger-1.0.jar:../custom-logger-v2/target/custom-logger-v2-1.0.jar"

echo "運行中..."
java -cp $CLASSPATH com.example.main.Main

echo "=== 執行完成 ==="
