# Spring Factories Example

這個專案展示了 Spring Factories 機制，透過 `META-INF/spring.factories` 文件來註冊和發現服務實作。

## 🏗️ 專案結構圖

```
📁 spring-factories (根目錄)
├── 📄 pom.xml                    # 父 POM（聚合器）
├── 📄 README.md                  # 專案說明文件
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
│   └── 📁 src/main/resources/META-INF/
│       └── 📄 spring.factories   # Spring Factories 註冊文件
│
├── 📁 custom-logger-v2/          # 實作模組 2
│   ├── 📄 pom.xml
│   ├── 📁 src/main/java/com/example/loggerv2/
│   │   └── 📄 CustomLoggerV2.java # 實作類別 (priority: 200)
│   └── 📁 src/main/resources/META-INF/
│       └── 📄 spring.factories   # Spring Factories 註冊文件
│
└── 📁 main-app/                  # 主應用程式
    ├── 📄 pom.xml
    ├── 📄 run.sh                 # 執行腳本
    └── 📁 src/main/java/com/example/main/
        └── 📄 Main.java          # 主程式
```

## 🔄 Spring Factories vs Java SPI

| 特性 | Spring Factories | Java SPI |
|------|------------------|----------|
| 配置文件 | `META-INF/spring.factories` | `META-INF/services/介面全名` |
| 載入器 | `SpringFactoriesLoader` | `ServiceLoader` |
| 格式 | Key=Value 格式 | 每行一個實作類別 |
| 依賴 | 需要 Spring Core | JDK 內建 |
| 靈活性 | 支援多種類型映射 | 僅支援介面對應 |

## 📁 Spring Factories 文件格式

### custom-logger/src/main/resources/META-INF/spring.factories
```properties
# Spring Factories 配置文件
# 格式: 介面類別名稱=實作類別名稱1,實作類別名稱2,...

com.example.api.Logger=com.example.logger.CustomLogger
```

### custom-logger-v2/src/main/resources/META-INF/spring.factories
```properties
# Spring Factories 配置文件
# 格式: 介面類別名稱=實作類別名稱1,實作類別名稱2,...

com.example.api.Logger=com.example.loggerv2.CustomLoggerV2
```

## 🎯 Spring Factories 運作流程

```
┌─────────────────────────────────────────────────────────────────┐
│                SpringFactoriesLoader 執行流程                    │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. SpringFactoriesLoader.loadFactories(Logger.class, classLoader)│
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. 掃描 classpath 中所有 JAR 的 META-INF/spring.factories 文件   │
└─────────────────────────────────────────────────────────────────┘
                                  │
                 ┌────────────────┼────────────────┐
                 ▼                ▼                ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│custom-logger.jar │ │custom-logger-v2  │ │其他 JAR 文件      │
│                  │ │    .jar          │ │                  │
│找到 spring.      │ │找到 spring.      │ │沒有 spring.      │
│factories 文件    │ │factories 文件    │ │factories 文件    │
│Key: Logger       │ │Key: Logger       │ │                  │
│Value: CustomLog  │ │Value: CustomLog  │ │                  │
│      ger         │ │      gerV2       │ │                  │
└──────────────────┘ └──────────────────┘ └──────────────────┘
                 │                │                │
                 └────────────────┼────────────────┘
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. 合併所有 spring.factories 文件中的 com.example.api.Logger 項目│
│    - com.example.logger.CustomLogger                           │
│    - com.example.loggerv2.CustomLoggerV2                       │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. 實例化所有實作類別:                                           │
│    - Class.forName() + newInstance()                           │
│    - 回傳 List<Logger>                                          │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. Main.java 選擇最高優先級:                                     │
│    CustomLoggerV2 (priority: 200) > CustomLogger (priority: 100)│
└─────────────────────────────────────────────────────────────────┘
```

## 📦 主要程式碼

### Main.java (使用 SpringFactoriesLoader)
```java
// 使用 SpringFactoriesLoader 載入所有 Logger 實作
List<Logger> loggers = SpringFactoriesLoader.loadFactories(
    Logger.class, 
    Main.class.getClassLoader()
);

// 選擇最高優先級的 Logger
Logger bestLogger = loggers.stream()
    .max(Comparator.comparing(Logger::getPriority))
    .orElse(null);
```

## 🚀 建置和執行

### 使用 Maven Exec Plugin（推薦）
```bash
# 建置所有模組
cd spring-factories
mvn clean package

# 執行主應用程式
mvn exec:java -pl main-app
```

### 使用執行腳本
```bash
# 建置所有模組
cd spring-factories
mvn clean package

# 使用提供的腳本執行
cd main-app
./run.sh
```

## 📊 預期輸出

```
Available loggers (via Spring Factories):
- CustomLogger (priority: 100)
- CustomLoggerV2 (priority: 200)

Selected: CustomLoggerV2
[CustomLoggerV2] Hello from Spring Factories!
```

## ✨ Spring Factories 的優勢

1. **統一配置**: 所有工廠配置都在同一個文件中
2. **類型安全**: 支援泛型和類型檢查
3. **載入控制**: 可以選擇性載入特定類型
4. **Spring 生態**: 與 Spring Framework 深度整合
5. **批量載入**: 一次載入多個實作

## 🔧 技術細節

- **Java 8 相容**
- **Maven 多模組專案**
- **Spring Core 5.1.8.RELEASE (Java 8 相容版本)**
- **使用 SpringFactoriesLoader**
- **透過 META-INF/spring.factories 文件進行服務註冊**

## 🛠️ JAR 文件內容結構

```
custom-logger-1.0.jar
├── com/example/logger/
│   └── CustomLogger.class
└── META-INF/
    └── spring.factories  ← 內容: "com.example.api.Logger=com.example.logger.CustomLogger"

custom-logger-v2-1.0.jar
├── com/example/loggerv2/
│   └── CustomLoggerV2.class
└── META-INF/
    └── spring.factories  ← 內容: "com.example.api.Logger=com.example.loggerv2.CustomLoggerV2"

main-app-1.0.jar
└── com/example/main/
    └── Main.class  ← 使用 SpringFactoriesLoader.loadFactories()
```

## 🎓 Spring Factories vs Java SPI 比較

### 相同點:
- 都支援服務發現機制
- 都使用 META-INF 目錄下的配置文件
- 都支援運行時動態載入

### 不同點:

#### Spring Factories:
- ✅ 支援一對多映射（一個 key 對應多個 value）
- ✅ 支援任意類型載入（不僅僅是介面）
- ✅ 配置更靈活（Key=Value 格式）
- ❌ 需要 Spring Core 依賴

#### Java SPI:
- ✅ JDK 內建，無外部依賴
- ✅ 標準化的服務發現機制
- ❌ 僅支援介面實作載入
- ❌ 配置相對簡單

## 📚 如何擴展

要添加新的 logger 實作：

1. **創建新模組** (例如 `custom-logger-v3`)
2. **實作 Logger 介面**
3. **創建 spring.factories 文件**：
   ```properties
   com.example.api.Logger=com.example.loggerv3.CustomLoggerV3
   ```
4. **設定適當的優先級**
5. **添加到 main-app 的依賴**

主程式會自動發現新的實作，無需修改任何現有代碼！
