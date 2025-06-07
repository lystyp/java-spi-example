# Java SPI 簡潔範例

這是一個極簡的Java SPI多模組範例，包含兩個獨立的Logger實作。

## 項目結構

```
├── pom.xml                 # 父級POM
├── logger-api/             # API模組 - 定義Logger接口
├── custom-logger/          # 第一個實作 (優先順序: 100)
├── custom-logger-v2/       # 第二個實作 (優先順序: 200)
└── main-app/               # 主程式 - 使用SPI載入實作
```

## 運行方式

### 方式1: 使用Maven運行
```bash
# 編譯安裝所有模組
mvn install

# 運行主程式
cd main-app
mvn exec:java
```

### 方式2: 打包jar並運行
```bash
# 編譯並打包所有模組
mvn clean package

# 方法2a: 使用完整classpath運行
cd main-app
java -cp target/main-app-1.0.jar:../logger-api/target/logger-api-1.0.jar:../custom-logger/target/custom-logger-1.0.jar:../custom-logger-v2/target/custom-logger-v2-1.0.jar com.example.main.Main

# 方法2b: 使用執行腳本（推薦）
cd main-app
./run.sh
```

## 運行結果

程式會自動發現所有Logger實作，並選擇優先順序最高的(CustomLoggerV2)來執行。

## SPI核心要素

1. **接口定義**: `Logger.java`
2. **實作類**: `CustomLogger.java`, `CustomLoggerV2.java`
3. **SPI配置**: `META-INF/services/com.example.api.Logger`
4. **載入機制**: `ServiceLoader.load(Logger.class)`
