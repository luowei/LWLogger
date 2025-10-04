# LWLogger Swift 版本使用说明

## 概述

`LWLogger_swift` 是 `LWLogger` 库的 Swift 子模块，包含了使用 Swift 编写的日志记录框架组件。

## 安装

### 使用 Swift 版本

如果你的项目使用 Swift，可以安装 Swift 版本：

```ruby
pod 'LWLogger_swift'
```

### 使用 Objective-C 版本

如果你的项目使用 Objective-C，可以安装原版本：

```ruby
pod 'LWLogger'
```

### 同时使用两个版本

如果需要同时使用 Objective-C 和 Swift 版本：

```ruby
pod 'LWLogger'
pod 'LWLogger_swift'
```

## Swift 文件列表

本 Swift 子模块包含以下文件：

- `LWLogUtil.swift` - 日志工具类
- `LWLogger.swift` - 日志记录器
- `LWLoggerView.swift` - 日志显示视图
- `LWLoggerExample.swift` - 日志示例
- `LWLogger+SwiftIntegration.swift` - Swift 集成扩展
- `LWLoggerQuickStart.swift` - 快速开始指南

## 特性

- 基于 CocoaLumberjack 封装
- 支持不同级别的日志记录
- 自动保存日志到文件
- 按日期生成压缩包
- Swift 友好的 API

## 依赖

- CocoaLumberjack ~> 3.6.0
- SSZipArchive

## 版本要求

- iOS 8.0+
- Swift 5.0+

## 许可证

LWLogger_swift 使用 MIT 许可证。详情请参见 LICENSE 文件。
