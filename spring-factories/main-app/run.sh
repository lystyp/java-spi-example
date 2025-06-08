#!/bin/bash

# Spring Factories Logger 執行腳本

echo "=== 執行 Spring Factories Logger ==="

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

# 設置classpath (包含 Spring Core)
CLASSPATH="target/main-app-1.0.jar"
CLASSPATH="$CLASSPATH:../logger-api/target/logger-api-1.0.jar"
CLASSPATH="$CLASSPATH:../custom-logger/target/custom-logger-1.0.jar"
CLASSPATH="$CLASSPATH:../custom-logger-v2/target/custom-logger-v2-1.0.jar"

# 添加 Spring Core JAR (特定版本)
SPRING_VERSION="5.1.8.RELEASE"
SPRING_CORE_JAR="$HOME/.m2/repository/org/springframework/spring-core/$SPRING_VERSION/spring-core-$SPRING_VERSION.jar"
if [ -f "$SPRING_CORE_JAR" ]; then
    CLASSPATH="$CLASSPATH:$SPRING_CORE_JAR"
else
    echo "警告: 找不到 Spring Core JAR (版本 $SPRING_VERSION)，請確保已執行 mvn install"
fi

# 添加其他必要的依賴
SPRING_JCL_JAR="$HOME/.m2/repository/org/springframework/spring-jcl/$SPRING_VERSION/spring-jcl-$SPRING_VERSION.jar"
if [ -f "$SPRING_JCL_JAR" ]; then
    CLASSPATH="$CLASSPATH:$SPRING_JCL_JAR"
fi

echo "運行中..."
java -cp "$CLASSPATH" com.example.main.Main

echo "=== 執行完成 ==="
