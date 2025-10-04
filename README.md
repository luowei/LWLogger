# LWLogger

[![CI Status](https://img.shields.io/travis/luowei/LWLogger.svg?style=flat)](https://travis-ci.org/luowei/LWLogger)
[![Version](https://img.shields.io/cocoapods/v/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![License](https://img.shields.io/cocoapods/l/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![Platform](https://img.shields.io/cocoapods/p/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)

[English](./README.md) | [中文版](./README_ZH.md)

---

## Overview

LWLogger is a powerful yet lightweight logging framework for iOS applications, built on top of [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). It provides comprehensive logging capabilities with automatic file management, intelligent log rotation, archiving, and export functionality designed for production-ready applications.

Whether you're debugging during development or collecting logs from production apps for support and diagnostics, LWLogger offers a simple API while maintaining the flexibility and power of CocoaLumberjack under the hood.

## Table of Contents

- [Swift Version](./README_SWIFT_VERSION.md)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage Guide](#usage-guide)
- [Log Rotation](#log-rotation)
- [Log Archiving and Export](#log-archiving-and-export)
- [Usage Examples](#comprehensive-usage-examples)
- [Advanced Usage](#advanced-usage)
- [API Documentation](#api-documentation)
- [Example Project](#example-project)
- [Dependencies](#dependencies)
- [Author](#author)
- [License](#license)

## Features

### Core Logging Capabilities
- **Simple API**: Easy-to-use logging macro `LWLog()` that works like NSLog
- **Multiple Log Levels**: Support for Verbose, Debug, Info, Warning, and Error levels
- **Automatic File Logging**: Logs are automatically written to files with configurable rotation
- **Console Output**: Logs are displayed in Xcode console during development
- **Debug/Release Configuration**: Logging can be disabled in release builds automatically
- **Thread-Safe**: Fully thread-safe logging operations powered by CocoaLumberjack

### Advanced Log Management
- **Automatic Log Rotation**: Intelligent daily log file rotation (24-hour cycle)
  - Time-based rotation with configurable intervals
  - Size-based rotation to prevent oversized log files
  - Automatic file naming with timestamps
- **Smart File Management**:
  - Configurable retention policy (default: 7 files)
  - Automatic cleanup of older log files
  - Efficient disk space management
- **Log Archiving & Export**:
  - Built-in ZIP compression for all log files
  - Timestamped archive file names
  - Easy sharing via standard iOS sharing mechanisms
- **Flexible Storage**: Customizable log directory locations
- **Built on CocoaLumberjack**: Leverages the powerful and proven CocoaLumberjack framework

## Requirements

- **iOS**: 8.0 or later
- **Xcode**: 10.0 or later
- **Objective-C**

## Installation

### CocoaPods (Recommended)

LWLogger is available through [CocoaPods](https://cocoapods.org). Add the following line to your `Podfile`:

```ruby
pod 'LWLogger'
```

Then run:
```bash
pod install
```

### Carthage

Add the following line to your `Cartfile`:
```ruby
github "luowei/LWLogger"
```

Then run:
```bash
carthage update
```

## Quick Start

### 1. Initialize LWLogger

Import and initialize LWLogger in your `AppDelegate`:

```objective-c
#import <LWLogger/LWLogger.h>

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Initialize logging configuration
    [LWLogUtil initLogConfig];

    LWLog(@"Application started successfully");
    return YES;
}
```

### 2. Log Messages

Use the `LWLog` macro to log messages anywhere in your code:

```objective-c
#import <LWLogger/LWLogger.h>

// Simple text logging
LWLog(@"Application started");

// Logging with format specifiers
LWLog(@"User logged in: %@", username);
LWLog(@"Function called: %s", __func__);

// Logging with multiple parameters
LWLog(@"Request URL: %@, Status Code: %d", url, statusCode);
```

### 3. Export Logs

Generate a ZIP archive of all log files for sharing or debugging:

```objective-c
// Generate ZIP file containing all logs
NSString *logZipPath = [LWLogUtil logZipPath];

// Share via UIActivityViewController
NSURL *url = [NSURL fileURLWithPath:logZipPath];
UIActivityViewController *activityVC = [[UIActivityViewController alloc]
    initWithActivityItems:@[url]
    applicationActivities:nil];
[self presentViewController:activityVC animated:YES completion:nil];
```

**Important Note**: In **DEBUG** builds, logs are written to both console and files. In **RELEASE** builds, `LWLog()` does nothing (logs are disabled for performance).

---

## Usage Guide

### Using Different Log Levels

For more granular control over logging, use CocoaLumberjack's log level macros directly:

```objective-c
#import <CocoaLumberjack/CocoaLumberjack.h>

// Different severity levels
DDLogVerbose(@"Detailed diagnostic information");
DDLogDebug(@"Debug information for troubleshooting");
DDLogInfo(@"General informational messages");
DDLogWarn(@"Warning: potential issues");
DDLogError(@"Error: something went wrong - %@", error);

// Log with context
DDLogInfo(@"User action: %@ at %@", actionName, [NSDate date]);
```

### Default Configuration

The default configuration provided by `[LWLogUtil initLogConfig]` includes:

| Setting | Value | Description |
|---------|-------|-------------|
| **Console Logging** | DDOSLogger | Logs displayed in Xcode console (DEBUG only) |
| **File Logging** | DDFileLogger | Logs written to files automatically |
| **Rolling Frequency** | 24 hours | New log file created daily |
| **Maximum Log Files** | 7 files | Keeps approximately one week of logs |
| **Log Level** | All levels | DDLogLevelAll (Verbose, Debug, Info, Warn, Error) |
| **Storage Location** | Library/Caches/Logs | Application's log directory |

### Custom Configuration

To customize the configuration, you can modify settings after initialization:

```objective-c
// Initialize with default config
[LWLogUtil initLogConfig];

// Optionally add custom configuration
// Access to full CocoaLumberjack APIs is available
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
fileLogger.rollingFrequency = 60 * 60 * 12; // 12-hour rotation
fileLogger.logFileManager.maximumNumberOfLogFiles = 14; // Keep 2 weeks
[DDLog addLogger:fileLogger];
```

### Log File Location

Log files are stored in the application's caches directory:

```objective-c
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
NSLog(@"Log directory: %@", logDirectory);
// Output: /path/to/app/Library/Caches/Logs
```

## Log Rotation

LWLogger implements intelligent log rotation to manage log files efficiently without consuming excessive disk space.

### Automatic Rotation

Logs are automatically rotated based on two criteria:

1. **Time-based Rotation**: By default, log files rotate every 24 hours
2. **Size-based Rotation**: Large log files are automatically split to prevent performance issues

```objective-c
// Default configuration (24-hour rotation)
[LWLogUtil initLogConfig];

// The system automatically creates new log files like:
// - app-2025-10-01.log
// - app-2025-10-02.log
// - app-2025-10-03.log
```

### Custom Rotation Configuration

You can customize the rotation behavior to suit your application's needs:

```objective-c
// Configure custom rotation settings
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];

// Rotate every 12 hours
fileLogger.rollingFrequency = 60 * 60 * 12; // 12 hours in seconds

// Rotate when file reaches 5MB
fileLogger.maximumFileSize = 5 * 1024 * 1024; // 5 MB

// Keep last 14 log files (2 weeks)
fileLogger.logFileManager.maximumNumberOfLogFiles = 14;

// Add to logging system
[DDLog addLogger:fileLogger];
```

### Rotation Strategies

#### Time-Based Rotation Examples

```objective-c
// Hourly rotation
fileLogger.rollingFrequency = 60 * 60; // 1 hour

// Every 6 hours
fileLogger.rollingFrequency = 60 * 60 * 6; // 6 hours

// Weekly rotation
fileLogger.rollingFrequency = 60 * 60 * 24 * 7; // 1 week

// No automatic time-based rotation (size-based only)
fileLogger.rollingFrequency = 0;
```

#### Size-Based Rotation Examples

```objective-c
// 1 MB files
fileLogger.maximumFileSize = 1024 * 1024;

// 10 MB files
fileLogger.maximumFileSize = 10 * 1024 * 1024;

// No size limit (not recommended)
fileLogger.maximumFileSize = 0;
```

### File Retention Policies

Control how many log files are kept before old files are automatically deleted:

```objective-c
// Keep only 3 most recent log files
fileLogger.logFileManager.maximumNumberOfLogFiles = 3;

// Keep 30 log files (about a month with daily rotation)
fileLogger.logFileManager.maximumNumberOfLogFiles = 30;

// Keep unlimited files (manage manually)
fileLogger.logFileManager.maximumNumberOfLogFiles = 0;
```

## Log Archiving and Export

LWLogger provides powerful features for archiving and exporting log files for debugging, user feedback, or support purposes.

### Basic Log Export

Export all log files as a single ZIP archive:

```objective-c
#import <LWLogger/LWLogger.h>

// Generate ZIP file of all logs
NSString *logZipPath = [LWLogUtil logZipPath];

// The ZIP file contains all current log files
NSLog(@"Logs exported to: %@", logZipPath);
```

### Sharing Logs via UIActivityViewController

```objective-c
- (void)exportAndShareLogs {
    // Generate ZIP file of all logs
    NSString *logZipPath = [LWLogUtil logZipPath];

    // Share the log file
    NSURL *url = [NSURL fileURLWithPath:logZipPath];
    NSArray *objectsToShare = @[url];

    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:objectsToShare
                                            applicationActivities:nil];

    // For iPad: specify source view for popover
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(
            CGRectGetMidX(self.view.bounds),
            CGRectGetMidY(self.view.bounds),
            0, 0
        );
    }

    // Present the share sheet
    [self presentViewController:controller animated:YES completion:nil];
}
```

### Exporting Logs via Email

```objective-c
#import <MessageUI/MessageUI.h>

- (void)emailLogs {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *logZipPath = [LWLogUtil logZipPath];
        NSData *logData = [NSData dataWithContentsOfFile:logZipPath];

        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;

        [mailVC setSubject:@"App Logs"];
        [mailVC setMessageBody:@"Please find the attached log files." isHTML:NO];
        [mailVC addAttachmentData:logData
                         mimeType:@"application/zip"
                         fileName:@"app-logs.zip"];

        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
```

### Uploading Logs to Server

```objective-c
- (void)uploadLogsToServer {
    NSString *logZipPath = [LWLogUtil logZipPath];
    NSURL *url = [NSURL URLWithString:@"https://your-server.com/api/logs"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    // Read log file data
    NSData *logData = [NSData dataWithContentsOfFile:logZipPath];

    // Create multipart form data
    NSString *boundary = @"LWLogger-Boundary";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"logfile\"; filename=\"logs.zip\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:logData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    request.HTTPBody = body;

    // Send request
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Upload failed: %@", error);
            } else {
                NSLog(@"Logs uploaded successfully");
            }
        }];
    [task resume];
}
```

### Automatic Log Cleanup After Export

```objective-c
- (void)exportAndCleanupLogs {
    // Export logs
    NSString *logZipPath = [LWLogUtil logZipPath];

    // After successful export, optionally clean up old logs
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    DDLogFileManagerDefault *logFileManager = (DDLogFileManagerDefault *)fileLogger.logFileManager;

    // Get all log file paths
    NSArray *logFilePaths = [logFileManager sortedLogFilePaths];

    // Delete all but the current log file
    for (NSString *logPath in logFilePaths) {
        if (![logPath isEqualToString:logFilePaths.firstObject]) {
            [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
        }
    }

    NSLog(@"Old logs cleaned up, keeping only current log");
}
```

### Archive File Details

The exported ZIP file:
- **Naming Format**: `feadbackLog-yyyy-MM-dd-HH:mm:ss.zip`
- **Contents**: All available log files (up to maximum configured)
- **Location**: Application's log directory
- **Size**: Compressed for efficient sharing
- **Sharing**: Compatible with email, AirDrop, cloud storage, and more

---

## Comprehensive Usage Examples

### Example 1: Complete App Integration

```objective-c
// AppDelegate.m
#import <LWLogger/LWLogger.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Initialize logging
    [LWLogUtil initLogConfig];
    LWLog(@"Application started successfully");

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    LWLog(@"Application will terminate");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    LWLog(@"Application entered background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    LWLog(@"Application will enter foreground");
}

@end
```

### Example 2: Network Request Logging

```objective-c
// NetworkManager.m
#import <LWLogger/LWLogger.h>

- (void)performRequest:(NSURLRequest *)request
            completion:(void(^)(NSData *data, NSError *error))completion {

    LWLog(@"Starting request: %@", request.URL);

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            if (error) {
                LWLog(@"Request failed: %@ - Error: %@", request.URL, error.localizedDescription);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                LWLog(@"Request succeeded: %@ - Status: %ld",
                      request.URL, (long)httpResponse.statusCode);
            }

            if (completion) {
                completion(data, error);
            }
        }];

    [task resume];
}
```

### Example 3: User Action Tracking

```objective-c
// ViewController.m
#import <LWLogger/LWLogger.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    LWLog(@"Screen loaded: %@", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LWLog(@"Screen appeared: %@", NSStringFromClass([self class]));
}

- (IBAction)buttonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    LWLog(@"Button tapped: %@ on screen: %@",
          button.titleLabel.text, NSStringFromClass([self class]));
}

- (void)userDidLogin:(NSString *)username {
    LWLog(@"User logged in: %@ at %@", username, [NSDate date]);
}
```

### Example 4: Error Handling and Logging

```objective-c
// DataManager.m
#import <LWLogger/LWLogger.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

- (BOOL)saveData:(NSDictionary *)data error:(NSError **)error {
    LWLog(@"Attempting to save data: %@", data);

    @try {
        // Attempt to save
        BOOL success = [self performSave:data];

        if (success) {
            DDLogInfo(@"Data saved successfully");
            return YES;
        } else {
            DDLogError(@"Failed to save data");
            return NO;
        }
    }
    @catch (NSException *exception) {
        DDLogError(@"Exception while saving data: %@ - Reason: %@",
                   exception.name, exception.reason);

        if (error) {
            *error = [NSError errorWithDomain:@"DataManagerError"
                                         code:100
                                     userInfo:@{NSLocalizedDescriptionKey: exception.reason}];
        }
        return NO;
    }
}
```

### Example 5: Feedback/Bug Report Feature

```objective-c
// SettingsViewController.m
#import <LWLogger/LWLogger.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>
@end

@implementation SettingsViewController

- (IBAction)sendFeedbackTapped:(id)sender {
    LWLog(@"User initiated feedback submission");
    [self showFeedbackOptions];
}

- (void)showFeedbackOptions {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Send Feedback"
        message:@"Include log files to help us diagnose issues?"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Send with Logs"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
        [self emailLogsToSupport];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Send without Logs"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
        [self emailFeedbackOnly];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleCancel
                                           handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)emailLogsToSupport {
    if (![MFMailComposeViewController canSendMail]) {
        [self showEmailNotConfiguredAlert];
        return;
    }

    LWLog(@"Preparing log files for email");

    // Generate log archive
    NSString *logZipPath = [LWLogUtil logZipPath];
    NSData *logData = [NSData dataWithContentsOfFile:logZipPath];

    // Prepare email
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;

    [mailVC setToRecipients:@[@"support@yourapp.com"]];
    [mailVC setSubject:@"App Feedback with Logs"];

    NSString *deviceInfo = [NSString stringWithFormat:
        @"Device: %@\nOS Version: %@\nApp Version: %@\n\n",
        [[UIDevice currentDevice] model],
        [[UIDevice currentDevice] systemVersion],
        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
    ];

    [mailVC setMessageBody:[deviceInfo stringByAppendingString:@"Please describe your issue:"]
                    isHTML:NO];

    [mailVC addAttachmentData:logData
                     mimeType:@"application/zip"
                     fileName:@"app-logs.zip"];

    [self presentViewController:mailVC animated:YES completion:^{
        LWLog(@"Email composer presented with logs");
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {

    switch (result) {
        case MFMailComposeResultSent:
            LWLog(@"Feedback email sent successfully");
            [self showAlert:@"Thank you!" message:@"Your feedback has been sent."];
            break;
        case MFMailComposeResultFailed:
            LWLog(@"Failed to send feedback email: %@", error.localizedDescription);
            [self showAlert:@"Error" message:@"Failed to send email. Please try again."];
            break;
        case MFMailComposeResultCancelled:
            LWLog(@"User cancelled feedback email");
            break;
        default:
            break;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
```

### Example 6: Performance Monitoring

```objective-c
// PerformanceLogger.h
#import <Foundation/Foundation.h>

@interface PerformanceLogger : NSObject
+ (void)logOperationStart:(NSString *)operationName;
+ (void)logOperationEnd:(NSString *)operationName;
@end

// PerformanceLogger.m
#import "PerformanceLogger.h"
#import <LWLogger/LWLogger.h>

@implementation PerformanceLogger

static NSMutableDictionary *_timers;

+ (void)initialize {
    if (self == [PerformanceLogger class]) {
        _timers = [NSMutableDictionary dictionary];
    }
}

+ (void)logOperationStart:(NSString *)operationName {
    _timers[operationName] = [NSDate date];
    LWLog(@"[Performance] Starting: %@", operationName);
}

+ (void)logOperationEnd:(NSString *)operationName {
    NSDate *startTime = _timers[operationName];
    if (startTime) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        LWLog(@"[Performance] Completed: %@ in %.3f seconds", operationName, duration);
        [_timers removeObjectForKey:operationName];
    }
}

@end

// Usage example
- (void)loadDataFromAPI {
    [PerformanceLogger logOperationStart:@"API Data Load"];

    [self.networkManager fetchData:^(NSArray *data, NSError *error) {
        [PerformanceLogger logOperationEnd:@"API Data Load"];

        if (data) {
            [PerformanceLogger logOperationStart:@"Data Processing"];
            [self processData:data];
            [PerformanceLogger logOperationEnd:@"Data Processing"];
        }
    }];
}
```

### Example 7: Custom Log Settings Screen

```objective-c
// LogSettingsViewController.m
#import <LWLogger/LWLogger.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation LogSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayCurrentLogSettings];
}

- (void)displayCurrentLogSettings {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    DDLogFileManagerDefault *manager = (DDLogFileManagerDefault *)fileLogger.logFileManager;

    NSArray *logFiles = [manager sortedLogFileInfos];
    NSUInteger fileCount = logFiles.count;

    unsigned long long totalSize = 0;
    for (DDLogFileInfo *fileInfo in logFiles) {
        totalSize += fileInfo.fileSize;
    }

    NSString *info = [NSString stringWithFormat:
        @"Log Files: %lu\nTotal Size: %.2f MB\nLog Directory: %@",
        (unsigned long)fileCount,
        totalSize / (1024.0 * 1024.0),
        [manager logsDirectory]
    ];

    self.logInfoLabel.text = info;
    LWLog(@"Displayed log settings: %@", info);
}

- (IBAction)exportLogsTapped:(id)sender {
    LWLog(@"Export logs requested from settings");

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:spinner];
    spinner.center = self.view.center;
    [spinner startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *logZipPath = [LWLogUtil logZipPath];

        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [spinner removeFromSuperview];

            NSURL *url = [NSURL fileURLWithPath:logZipPath];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                initWithActivityItems:@[url]
                applicationActivities:nil];

            [self presentViewController:activityVC animated:YES completion:nil];
        });
    });
}

- (IBAction)clearLogsTapped:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Clear Logs"
        message:@"Are you sure you want to delete all log files?"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                                             style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action) {
        [self clearAllLogs];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleCancel
                                           handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearAllLogs {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    DDLogFileManagerDefault *manager = (DDLogFileManagerDefault *)fileLogger.logFileManager;
    NSArray *logFiles = [manager sortedLogFilePaths];

    NSUInteger deletedCount = 0;
    for (NSString *logPath in logFiles) {
        if ([[NSFileManager defaultManager] removeItemAtPath:logPath error:nil]) {
            deletedCount++;
        }
    }

    LWLog(@"Cleared %lu log files", (unsigned long)deletedCount);
    [self displayCurrentLogSettings];

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Success"
        message:[NSString stringWithFormat:@"Deleted %lu log files", (unsigned long)deletedCount]
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                           handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
```

---

## API Documentation

### LWLogUtil Class

The `LWLogUtil` class provides the main interface for configuring and managing LWLogger.

#### Methods

##### `+ (void)initLogConfig`

Initializes the logging system with default configuration.

**Description:**
- Configures console logging (DEBUG mode only)
- Configures file logging with automatic rotation
- Sets up default log file retention policy
- Enables all log levels

**Usage:**
```objective-c
[LWLogUtil initLogConfig];
```

**Best Practice:** Call this method in your `AppDelegate`'s `application:didFinishLaunchingWithOptions:` method.

---

##### `+ (NSString *)logZipPath`

Creates a ZIP archive of all log files and returns the file path.

**Returns:**
- `NSString *` - Full path to the generated ZIP file

**Description:**
- Collects all current log files
- Compresses them into a single ZIP archive
- Generates timestamped filename: `feadbackLog-yyyy-MM-dd-HH:mm:ss.zip`
- Saves to application's log directory

**Usage:**
```objective-c
NSString *zipPath = [LWLogUtil logZipPath];
NSLog(@"Log archive created at: %@", zipPath);
```

**Common Use Cases:**
- User feedback/bug reporting
- Support diagnostics
- Log analysis
- Sharing via email, AirDrop, or cloud storage

---

### LWLog Macro

The `LWLog` macro provides a simple logging interface similar to `NSLog`.

**Syntax:**
```objective-c
LWLog(format, ...)
```

**Parameters:**
- `format` - NSString format specifier
- `...` - Variable arguments matching the format specifiers

**Behavior:**
- **DEBUG mode**: Logs to console and file (equivalent to `DDLogInfo`)
- **RELEASE mode**: Compiles to nothing (no performance impact)

**Example:**
```objective-c
LWLog(@"User logged in: %@", username);
LWLog(@"API Response: status=%d, data=%@", statusCode, responseData);
```

**Thread Safety:** Fully thread-safe, can be called from any thread.

---

### CocoaLumberjack Integration

LWLogger is built on CocoaLumberjack, giving you access to all its powerful features:

#### Log Levels

| Macro | Level | Use Case |
|-------|-------|----------|
| `DDLogVerbose()` | Verbose | Detailed diagnostic information |
| `DDLogDebug()` | Debug | Debug information for developers |
| `DDLogInfo()` | Info | General informational messages |
| `DDLogWarn()` | Warning | Potential issues or deprecated usage |
| `DDLogError()` | Error | Errors and exceptions |

#### Logger Types

- **DDOSLogger** - Console output (Xcode/system log)
- **DDFileLogger** - File-based logging with rotation
- **DDTTYLogger** - XcodeColors support for colorized output
- **Custom Loggers** - Create your own logger implementations

#### File Management

Access CocoaLumberjack's file management capabilities:

```objective-c
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
DDLogFileManagerDefault *manager = (DDLogFileManagerDefault *)fileLogger.logFileManager;

// Get log directory
NSString *logsDirectory = [manager logsDirectory];

// Get all log files
NSArray<DDLogFileInfo *> *logFiles = [manager sortedLogFileInfos];

// Iterate through log files
for (DDLogFileInfo *fileInfo in logFiles) {
    NSLog(@"File: %@, Size: %llu bytes", fileInfo.fileName, fileInfo.fileSize);
}
```

---

## Example Project

To run the example project:

1. Clone the repository
2. Navigate to the Example directory
3. Run `pod install`
4. Open `LWLogger.xcworkspace`
5. Build and run the project

The example project demonstrates:
- Basic logging setup and initialization
- Logging messages in various scenarios
- Different log levels and formatting
- Exporting and sharing log files
- Performance monitoring with logs
- User feedback feature with log attachment
- Log management and settings interface

## Advanced Usage

### Direct CocoaLumberjack Access

Since LWLogger is built on CocoaLumberjack, you can use all CocoaLumberjack features:

```objective-c
#import <CocoaLumberjack/CocoaLumberjack.h>

// Use different log levels
DDLogVerbose(@"Verbose message");
DDLogDebug(@"Debug message");
DDLogInfo(@"Info message");
DDLogWarn(@"Warning message");
DDLogError(@"Error message");

// Add custom loggers
[DDLog addLogger:[DDTTYLogger sharedInstance]];

// Configure custom file logger settings
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
fileLogger.rollingFrequency = 60 * 60 * 12; // 12-hour rotation
fileLogger.logFileManager.maximumNumberOfLogFiles = 14; // Keep 14 files
[DDLog addLogger:fileLogger];
```

### Custom Log Formatters

Create custom formatters to control the appearance of your log messages:

```objective-c
// CustomLogFormatter.h
#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface CustomLogFormatter : NSObject <DDLogFormatter>
@end

// CustomLogFormatter.m
@implementation CustomLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage.flag) {
        case DDLogFlagError:   logLevel = @"ERROR"; break;
        case DDLogFlagWarning: logLevel = @"WARN "; break;
        case DDLogFlagInfo:    logLevel = @"INFO "; break;
        case DDLogFlagDebug:   logLevel = @"DEBUG"; break;
        default:               logLevel = @"VERB "; break;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:logMessage.timestamp];

    return [NSString stringWithFormat:@"%@ [%@] [%@:%lu] %@",
            dateString,
            logLevel,
            logMessage.fileName,
            (unsigned long)logMessage.line,
            logMessage.message];
}

@end

// Usage
DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
[fileLogger setLogFormatter:[[CustomLogFormatter alloc] init]];
[DDLog addLogger:fileLogger];
```

### Custom Log File Manager

Implement a custom file manager to control log file storage location and naming:

```objective-c
// CustomLogFileManager.h
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface CustomLogFileManager : DDLogFileManagerDefault
@end

// CustomLogFileManager.m
@implementation CustomLogFileManager

- (NSString *)logsDirectory {
    // Store logs in Documents directory instead of Caches
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *logsDirectory = [documentsDirectory stringByAppendingPathComponent:@"AppLogs"];

    // Create directory if it doesn't exist
    if (![[NSFileManager defaultManager] fileExistsAtPath:logsDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logsDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }

    return logsDirectory;
}

- (NSString *)newLogFileName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    return [NSString stringWithFormat:@"MyApp_%@.log", dateString];
}

@end

// Usage
CustomLogFileManager *logFileManager = [[CustomLogFileManager alloc] init];
DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
[DDLog addLogger:fileLogger];
```

### Conditional Logging

Log different information based on build configuration or runtime conditions:

```objective-c
// Use preprocessor macros for build-specific logging
#ifdef DEBUG
    #define DEBUG_LOG(fmt, ...) DDLogDebug(fmt, ##__VA_ARGS__)
#else
    #define DEBUG_LOG(fmt, ...)
#endif

// Runtime conditional logging
- (void)performOperation {
    if ([self.delegate respondsToSelector:@selector(shouldLogVerbose)] &&
        [self.delegate shouldLogVerbose]) {
        DDLogVerbose(@"Performing operation with detailed logging");
    } else {
        DDLogInfo(@"Performing operation");
    }
}
```

### Log Level Configuration per Module

Control log levels for different parts of your application:

```objective-c
// Define log levels for different modules
static const DDLogLevel ddLogLevel = DDLogLevelVerbose; // Default level

// In specific modules/files
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF NetworkModuleLogLevel
static const DDLogLevel NetworkModuleLogLevel = DDLogLevelInfo;

// Now logs in this file use the NetworkModuleLogLevel
DDLogDebug(@"This won't appear - below INFO level");
DDLogInfo(@"This will appear");
```

### Asynchronous Logging

Configure asynchronous logging for better performance:

```objective-c
// Enable asynchronous logging (default in CocoaLumberjack)
DDLogInfo(@"This is logged asynchronously by default");

// Force synchronous logging for critical messages
DDLogError(@"Critical error occurred");
[DDLog flushLog]; // Force all pending logs to be written

// At app termination
- (void)applicationWillTerminate:(UIApplication *)application {
    LWLog(@"Application terminating");
    [DDLog flushLog]; // Ensure all logs are written before exit
}
```

### Multiple File Loggers

Use multiple file loggers for different purposes:

```objective-c
// General application logger
DDFileLogger *generalLogger = [[DDFileLogger alloc] init];
generalLogger.logFileManager.logFilesDiskQuota = 10 * 1024 * 1024; // 10 MB total
[DDLog addLogger:generalLogger];

// Separate logger for network requests
CustomLogFileManager *networkLogManager = [[CustomLogFileManager alloc] init];
DDFileLogger *networkLogger = [[DDFileLogger alloc] initWithLogFileManager:networkLogManager];
networkLogger.logFileManager.maximumNumberOfLogFiles = 3;
[DDLog addLogger:networkLogger];

// Log to specific logger using log contexts
DDLogInfo(@"General application log");
```

### Remote Logging

Send logs to a remote server in real-time:

```objective-c
// RemoteLogger.h
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface RemoteLogger : DDAbstractLogger
@property (nonatomic, strong) NSURL *serverURL;
@end

// RemoteLogger.m
@implementation RemoteLogger

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *logString = logMessage.message;

    // Send to server asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendLogToServer:logString];
    });
}

- (void)sendLogToServer:(NSString *)logString {
    if (!self.serverURL) return;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.serverURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *payload = @{
        @"log": logString,
        @"timestamp": @([[NSDate date] timeIntervalSince1970]),
        @"device": [[UIDevice currentDevice] model]
    };

    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:payload
                                                       options:0
                                                         error:nil];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request] resume];
}

@end

// Usage
RemoteLogger *remoteLogger = [[RemoteLogger alloc] init];
remoteLogger.serverURL = [NSURL URLWithString:@"https://logs.yourserver.com/api/logs"];
[DDLog addLogger:remoteLogger];
```

### Log Filtering

Filter logs based on custom criteria:

```objective-c
// LogFilter.h
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface LogFilter : NSObject <DDLogFormatter>
@property (nonatomic, copy) NSArray<NSString *> *excludedKeywords;
@end

// LogFilter.m
@implementation LogFilter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    // Filter out messages containing excluded keywords
    for (NSString *keyword in self.excludedKeywords) {
        if ([logMessage.message containsString:keyword]) {
            return nil; // Suppress this log message
        }
    }

    return logMessage.message;
}

@end

// Usage
LogFilter *filter = [[LogFilter alloc] init];
filter.excludedKeywords = @[@"password", @"token", @"secret"];

DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
[fileLogger setLogFormatter:filter];
[DDLog addLogger:fileLogger];
```

---

## Dependencies

LWLogger is built on top of the following open-source libraries:

| Library | Version | Purpose |
|---------|---------|---------|
| [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) | ~> 3.6.0 | Fast & flexible logging framework |
| [SSZipArchive](https://github.com/ZipArchive/ZipArchive) | Latest | ZIP compression for log export |

These dependencies are automatically managed by CocoaPods or Carthage when you install LWLogger.

---

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please:

1. Check the [Issues](https://github.com/luowei/LWLogger/issues) page to see if it's already reported
2. Open a new issue with detailed information
3. Submit a pull request with your improvements

### Guidelines for Pull Requests

- Follow the existing code style and conventions
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation if needed

---

## Author

**luowei**
Email: luowei@wodedata.com

---

## License

LWLogger is available under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

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

---

## Support

If you find LWLogger helpful, please consider:
- Giving it a star on [GitHub](https://github.com/luowei/LWLogger)
- Sharing it with other iOS developers
- Contributing improvements or bug fixes

For questions, issues, or support, please open an issue on GitHub.

---

**Made with ❤️ for the iOS developer community**
