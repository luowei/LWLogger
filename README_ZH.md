# LWLogger

[![CI Status](https://img.shields.io/travis/luowei/LWLogger.svg?style=flat)](https://travis-ci.org/luowei/LWLogger)
[![Version](https://img.shields.io/cocoapods/v/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![License](https://img.shields.io/cocoapods/l/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![Platform](https://img.shields.io/cocoapods/p/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)

## 简介

LWLogger 是一个轻量级的 iOS 日志记录框架，基于 [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) 封装。它提供了简单易用的日志记录功能，支持不同级别的日志输出，自动保存日志文件，并支持按日期生成日志压缩包，方便日志的收集和分析。

### 主要特性

- **简单易用**：只需一行代码初始化，即可开始使用
- **多级别日志**：支持 Debug、Info、Warning、Error 等多种日志级别
- **自动管理**：自动创建和管理日志文件，支持日志文件的自动滚动
- **日志归档**：支持将日志文件打包成 ZIP 格式，方便分享和上传
- **灵活配置**：基于 CocoaLumberjack，可根据需求进行扩展配置
- **调试模式**：在 Debug 模式下输出日志，Release 模式自动关闭，保护应用性能

## 系统要求

- iOS 8.0 或更高版本
- Xcode 9.0 或更高版本

## 安装

### CocoaPods

LWLogger 可通过 [CocoaPods](https://cocoapods.org) 安装。在您的 Podfile 中添加以下内容：

```ruby
pod 'LWLogger'
```

然后运行：

```bash
pod install
```

### Carthage

LWLogger 也支持 [Carthage](https://github.com/Carthage/Carthage)。在您的 Cartfile 中添加：

```ruby
github "luowei/LWLogger"
```

然后运行：

```bash
carthage update
```

## 使用方法

### 1. 初始化配置

在应用启动时初始化日志配置，通常在 `AppDelegate` 的 `application:didFinishLaunchingWithOptions:` 方法中调用：

```objective-c
#import <LWLogger/LWLogger.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化日志配置
    [LWLogUtil initLogConfig];

    return YES;
}
```

### 2. 记录日志

使用 `LWLog` 宏来记录日志信息：

```objective-c
#import <LWLogger/LWLogger.h>

- (void)viewDidLoad {
    [super viewDidLoad];

    // 记录日志
    LWLog(@"视图已加载");
    LWLog(@"当前方法: %s", __func__);
    LWLog(@"用户ID: %@, 用户名: %@", userId, userName);
}
```

**注意**：`LWLog` 宏仅在 Debug 模式下输出日志。在 Release 模式下，日志调用会被编译器优化掉，不会产生任何性能开销。

### 3. 获取日志压缩包

当需要导出日志文件时（例如用户反馈或错误报告），可以生成日志的 ZIP 压缩包：

```objective-c
// 生成日志压缩包并获取路径
NSString *logZipPath = [LWLogUtil logZipPath];

// 分享日志文件
NSURL *url = [NSURL fileURLWithPath:logZipPath];
NSArray *objectsToShare = @[url];
UIActivityViewController *controller = [[UIActivityViewController alloc]
                                        initWithActivityItems:objectsToShare
                                        applicationActivities:nil];
[self presentViewController:controller animated:YES completion:nil];
```

## API 文档

### LWLogUtil

日志工具类，提供日志配置和管理功能。

#### 方法

##### `+ (void)initLogConfig`

初始化日志配置。该方法会配置以下功能：

- 添加系统日志输出（DDOSLogger），日志会输出到 Xcode 控制台
- 添加文件日志输出（DDFileLogger），日志会保存到应用的日志目录
- 设置日志文件滚动频率为 24 小时
- 最多保留 7 个日志文件（默认保留一周的日志）

**使用示例**：

```objective-c
[LWLogUtil initLogConfig];
```

##### `+ (NSString *)logZipPath`

生成日志压缩包并返回文件路径。

该方法会将所有日志文件打包成一个 ZIP 文件，文件名格式为 `feadbackLog-yyyy-MM-dd-HH:mm:ss.zip`。

**返回值**：
- `NSString *` - 日志 ZIP 文件的完整路径

**使用示例**：

```objective-c
NSString *zipPath = [LWLogUtil logZipPath];
NSLog(@"日志文件已保存到: %@", zipPath);
```

### LWLog 宏

用于记录日志信息的宏定义。

**语法**：

```objective-c
LWLog(format, ...)
```

**参数**：
- `format` - NSString 格式化字符串
- `...` - 可变参数列表

**行为**：
- 在 **Debug 模式**下：等同于 `DDLogInfo`，会输出日志到控制台和文件
- 在 **Release 模式**下：宏展开为空，不会产生任何代码

**使用示例**：

```objective-c
// 简单日志
LWLog(@"应用启动完成");

// 格式化日志
LWLog(@"用户登录: %@", username);
LWLog(@"请求URL: %@, 状态码: %d", url, statusCode);

// 使用内置宏
LWLog(@"当前类: %@", NSStringFromClass([self class]));
LWLog(@"当前方法: %s", __func__);
LWLog(@"当前行号: %d", __LINE__);
```

## 高级配置

### 自定义日志级别

如果需要使用不同的日志级别，可以直接使用 CocoaLumberjack 提供的日志宏：

```objective-c
#import <CocoaLumberjack/CocoaLumberjack.h>

// 不同级别的日志
DDLogVerbose(@"详细信息");
DDLogDebug(@"调试信息");
DDLogInfo(@"一般信息");
DDLogWarn(@"警告信息");
DDLogError(@"错误信息");
```

### 修改日志配置

您可以根据需求自定义日志配置：

```objective-c
// 自定义文件日志配置
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];

// 修改滚动频率（例如：每小时滚动一次）
fileLogger.rollingFrequency = 60 * 60; // 1 hour

// 修改最大文件数量（例如：保留 30 个日志文件）
fileLogger.logFileManager.maximumNumberOfLogFiles = 30;

// 修改最大文件大小（例如：单个文件最大 5MB）
fileLogger.maximumFileSize = 5 * 1024 * 1024; // 5MB

// 添加到日志系统
[DDLog addLogger:fileLogger];
```

### 添加自定义格式化器

```objective-c
// 创建自定义格式化器
@interface CustomLogFormatter : NSObject <DDLogFormatter>
@end

@implementation CustomLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage.flag) {
        case DDLogFlagError: logLevel = @"[错误]"; break;
        case DDLogFlagWarning: logLevel = @"[警告]"; break;
        case DDLogFlagInfo: logLevel = @"[信息]"; break;
        case DDLogFlagDebug: logLevel = @"[调试]"; break;
        default: logLevel = @"[详细]"; break;
    }

    return [NSString stringWithFormat:@"%@ %@: %@",
            logLevel, logMessage.function, logMessage.message];
}

@end

// 使用自定义格式化器
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
[fileLogger setLogFormatter:[[CustomLogFormatter alloc] init]];
[DDLog addLogger:fileLogger];
```

## 日志文件位置

日志文件默认保存在应用的 Library/Caches/Logs 目录下。您可以通过以下代码获取日志目录：

```objective-c
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
NSString *logsDirectory = [fileLogger.logFileManager logsDirectory];
NSLog(@"日志目录: %@", logsDirectory);
```

## 示例项目

项目中包含了一个完整的示例应用，展示了如何使用 LWLogger。

运行示例项目：

1. 克隆仓库：
   ```bash
   git clone https://gitlab.com/ioslibraries1/lwlogger.git
   cd lwlogger/Example
   ```

2. 安装依赖：
   ```bash
   pod install
   ```

3. 打开工作空间：
   ```bash
   open LWLogger.xcworkspace
   ```

4. 运行示例应用

示例应用演示了：
- 日志的初始化配置
- 日志信息的记录
- 日志文件的导出和分享

## 常见问题

### Q1: 为什么在 Release 模式下看不到日志？

**A**: 这是设计行为。`LWLog` 宏在 Release 模式下会被编译器优化掉，以避免性能开销和信息泄露。如果需要在 Release 模式也输出日志，可以直接使用 `DDLogInfo` 等 CocoaLumberjack 的日志宏。

### Q2: 如何修改日志文件的保留数量？

**A**: 在初始化配置时设置 `maximumNumberOfLogFiles` 属性：

```objective-c
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
fileLogger.logFileManager.maximumNumberOfLogFiles = 30; // 保留 30 个日志文件
[DDLog addLogger:fileLogger];
```

### Q3: 日志文件占用空间太大怎么办？

**A**: 可以通过以下方式控制：

1. 减少日志文件保留数量
2. 降低日志级别（只记录重要日志）
3. 设置单个文件的最大大小
4. 定期清理旧的日志文件

### Q4: 如何在崩溃时保存日志？

**A**: CocoaLumberjack 已经处理了应用终止时的日志保存。但如果需要捕获崩溃日志，建议集成专业的崩溃收集工具（如 Crashlytics 或 Bugly）。

### Q5: 可以将日志输出到自定义位置吗？

**A**: 可以。您可以实现自定义的 `DDLogFileManager` 来指定日志文件的存储位置：

```objective-c
@interface CustomLogFileManager : DDLogFileManagerDefault
@end

@implementation CustomLogFileManager

- (NSString *)logsDirectory {
    NSString *customPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES) firstObject];
    return [customPath stringByAppendingPathComponent:@"MyLogs"];
}

@end

// 使用自定义文件管理器
CustomLogFileManager *logFileManager = [[CustomLogFileManager alloc] init];
DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
[DDLog addLogger:fileLogger];
```

## 依赖库

LWLogger 依赖以下第三方库：

- **[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)** (~> 3.6.0) - 强大的日志框架
- **[SSZipArchive](https://github.com/ZipArchive/ZipArchive)** - ZIP 文件压缩和解压

## 版本历史

### 1.0.0
- 初始版本发布
- 基于 CocoaLumberjack 3.6.0
- 支持日志文件自动管理
- 支持日志文件 ZIP 打包

## 作者

**luowei**
Email: luowei@wodedata.com

## 许可协议

LWLogger 使用 MIT 许可协议。详情请参阅 [LICENSE](LICENSE) 文件。

```
MIT License

Copyright (c) 2019 luowei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进 LWLogger！

在提交 PR 之前，请确保：

1. 代码风格符合项目规范
2. 添加了必要的注释
3. 测试通过
4. 更新了相关文档

## 相关链接

- [GitHub 仓库](https://github.com/luowei/LWLogger)
- [CocoaPods 页面](https://cocoapods.org/pods/LWLogger)
- [CocoaLumberjack 官方文档](https://github.com/CocoaLumberjack/CocoaLumberjack)
- [SSZipArchive 官方文档](https://github.com/ZipArchive/ZipArchive)

---

如有任何问题或建议，欢迎通过 [Issues](https://gitlab.com/ioslibraries1/lwlogger/issues) 反馈。
