# Java SPI (Service Provider Interface) Example

這個專案展示了 Java Service Provider Interface (SPI) 機制，透過多個 logger 實作來自動發現和基於優先級選擇的範例。

## 🏗️ 專案結構圖

```
📁 SPI (根目錄)
├── 📄 pom.xml                    # 父 POM（聚合器）
├── 📄 README.md                  # 專案說明文件
├── 📄 .gitignore                 # Git 忽略文件
│
├── 📁 logger-api/                # API 模組
│   ├── 📄 pom.xml
│   └── 📁 src/main/java/com/example/api/
│       └── 📄 Logger.java        # 服務介面
│
├── 📁 custom-logger/             # 實作模組 1
│   ├── 📄 pom.xml
│   ├── 📁 src/main/java/com/example/logger/
│   │   └── 📄 CustomLogger.java  # 實作類別 (priority: 100)
│   └── 📁 src/main/resources/META-INF/services/
│       └── 📄 com.example.api.Logger  # SPI 註冊文件
│
├── 📁 custom-logger-v2/          # 實作模組 2
│   ├── 📄 pom.xml
│   ├── 📁 src/main/java/com/example/loggerv2/
│   │   └── 📄 CustomLoggerV2.java # 實作類別 (priority: 200)
│   └── 📁 src/main/resources/META-INF/services/
│       └── 📄 com.example.api.Logger  # SPI 註冊文件
│
└── 📁 main-app/                  # 主應用程式
    ├── 📄 pom.xml
    ├── 📄 run.sh                 # 執行腳本
    └── 📁 src/main/java/com/example/main/
        └── 📄 Main.java          # 主程式
```

## 🔄 模組依賴關係圖

```
┌─────────────┐
│ logger-api  │ ◄─────────┐
│             │           │
│ Logger      │           │
│ interface   │           │
└─────────────┘           │
       ▲                  │
       │                  │
       │ implements       │ depends on
       │                  │
┌─────────────┐           │
│custom-logger│           │
│             │           │
│CustomLogger │           │
│(priority100)│           │
└─────────────┘           │
       ▲                  │
       │                  │
       │ implements       │
       │                  │
┌─────────────┐           │
│custom-logger│           │
│    -v2      │           │
│CustomLogger │           │
│   V2        │           │
│(priority200)│           │
└─────────────┘           │
       ▲                  │
       │                  │
       │ discovers via    │
       │ ServiceLoader    │
       │                  │
┌─────────────┐           │
│  main-app   │───────────┘
│             │
│    Main     │
│  program    │
└─────────────┘
```

## 🎯 SPI 運作流程圖

```
┌─────────────────────────────────────────────────────────────────┐
│                    ServiceLoader 執行流程                        │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. ServiceLoader.load(Logger.class)                            │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. 掃描 classpath 中所有 JAR 的 META-INF/services/              │
│    com.example.api.Logger 文件                                 │
└─────────────────────────────────────────────────────────────────┘
                                  │
                 ┌────────────────┼────────────────┐
                 ▼                ▼                ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│custom-logger.jar │ │custom-logger-v2  │ │其他 JAR 文件      │
│                  │ │    .jar          │ │                  │
│找到服務文件       │ │找到服務文件       │ │沒有服務文件       │
│內容:             │ │內容:             │ │                  │
│CustomLogger      │ │CustomLoggerV2    │ │                  │
└──────────────────┘ └──────────────────┘ └──────────────────┘
                 │                │                │
                 └────────────────┼────────────────┘
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. 收集實作類別列表:                                             │
│    - com.example.logger.CustomLogger                           │
│    - com.example.loggerv2.CustomLoggerV2                       │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. 當呼叫 iterator() 時載入類別:                                 │
│    - Class.forName() + newInstance()                           │
│    - 建立實際物件                                               │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. Main.java 選擇最高優先級:                                     │
│    CustomLoggerV2 (priority: 200) > CustomLogger (priority: 100)│
└─────────────────────────────────────────────────────────────────┘
```

## 📦 模組詳細說明

### logger-api
定義 `Logger` 介面，包含以下方法：
- `log(String message)` - 記錄訊息
- `getName()` - 取得 logger 名稱
- `getPriority()` - 取得 logger 優先級（數值越高越優先）

### custom-logger
實作 `CustomLogger`，優先級為 100。
包含 `META-INF/services/com.example.api.Logger` 文件進行 SPI 註冊。

### custom-logger-v2
實作 `CustomLoggerV2`，優先級為 200。
包含 `META-INF/services/com.example.api.Logger` 文件進行 SPI 註冊。

### main-app
主應用程式：
1. 使用 `ServiceLoader.load(Logger.class)` 發現實作
2. 選擇具有最高優先級的 logger
3. 執行選定的 logger

## 🎯 SPI 機制運作原理

### META-INF/services 和 Classpath 的關係

1. **META-INF/services**: 用於 SPI 機制來**發現**服務實作類別
2. **Classpath (-cp)**: 用於 JVM **載入**實際的 class 文件

### 實際執行過程

當執行 `ServiceLoader.load(Logger.class)` 時：

1. **確定服務文件路徑**: `META-INF/services/com.example.api.Logger`
2. **掃描 ClassPath 中的所有 JAR**:
   - `custom-logger.jar` → 找到服務文件，內容: `com.example.logger.CustomLogger`
   - `custom-logger-v2.jar` → 找到服務文件，內容: `com.example.loggerv2.CustomLoggerV2`
3. **收集實作類別名稱**
4. **延遲載入**: 當呼叫 iterator() 時才真正載入類別
5. **類別實例化**: 使用反射建立物件實例

## 🚀 建置和執行

### 使用 Maven Exec Plugin（推薦）
```bash
# 建置所有模組
mvn clean package

# 執行主應用程式
mvn exec:java -pl main-app
```

### 使用 JAR 和 Classpath
```bash
# 建置所有模組
mvn clean package

# 使用明確的 classpath 執行
cd main-app
java -cp "target/main-app-1.0.jar:../logger-api/target/logger-api-1.0.jar:../custom-logger/target/custom-logger-1.0.jar:../custom-logger-v2/target/custom-logger-v2-1.0.jar" com.example.main.Main
```

### 使用執行腳本
```bash
# 建置所有模組
mvn clean package

# 使用提供的腳本執行
cd main-app
./run.sh
```

## 📊 預期輸出

```
Available loggers:
- CustomLogger (priority: 100)
- CustomLoggerV2 (priority: 200)

Selected: CustomLoggerV2
[CustomLoggerV2] Hello from SPI!
```

## ✨ 核心特性

- **可插拔架構**: 可在不修改現有代碼的情況下添加新的 logger 實作
- **基於優先級的選擇**: 自動選擇具有最高優先級的實作
- **鬆耦合**: 主應用程式不需要知道具體的實作類別
- **運行時發現**: 使用 ServiceLoader 在運行時發現實作
- **獨立模組**: 每個模組都可以獨立開發和部署

## 🔧 技術細節

- Java 8 相容
- Maven 多模組專案
- 除了 JDK 外無外部依賴
- 使用標準 Java SPI 機制 (`java.util.ServiceLoader`)
- 透過 `META-INF/services/` 文件進行服務註冊

## 🛠️ JAR 文件內容結構

```
custom-logger-1.0.jar
├── com/example/logger/
│   └── CustomLogger.class
└── META-INF/
    └── services/
        └── com.example.api.Logger  ← 內容: "com.example.logger.CustomLogger"

custom-logger-v2-1.0.jar
├── com/example/loggerv2/
│   └── CustomLoggerV2.class
└── META-INF/
    └── services/
        └── com.example.api.Logger  ← 內容: "com.example.loggerv2.CustomLoggerV2"

main-app-1.0.jar
└── com/example/main/
    └── Main.class  ← 使用 ServiceLoader.load(Logger.class)
```

## 🎓 學習要點

1. **SPI 不是自動生成**: META-INF/services 文件需要手動創建
2. **延遲載入**: ServiceLoader 使用延遲載入機制
3. **classpath 必要性**: 即使有 SPI 註冊，JVM 仍需要 classpath 來找到 class 文件
4. **優先級設計**: 透過自定義的 getPriority() 方法實現選擇邏輯
5. **可擴展性**: 新增實作只需添加新模組和對應的 SPI 註冊文件

## 🎯 執行時 Classpath 結構

```
java -cp "main-app-1.0.jar:logger-api-1.0.jar:custom-logger-1.0.jar:custom-logger-v2-1.0.jar"
          │                │                 │                   │
          │                │                 │                   └─ 實作 2 + SPI 註冊
          │                │                 └─ 實作 1 + SPI 註冊
          │                └─ 介面定義
          └─ 主程式 (使用 ServiceLoader)
```

## 📚 如何擴展

要添加新的 logger 實作：

1. **創建新模組** (例如 `custom-logger-v3`)
2. **實作 Logger 介面**
3. **創建 SPI 註冊文件** `META-INF/services/com.example.api.Logger`
4. **設定適當的優先級**
5. **添加到 main-app 的依賴**

主程式會自動發現新的實作，無需修改任何現有代碼！
