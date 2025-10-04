//
//  LWLoggerQuickStart.swift
//  LWLogger
//
//  Quick reference guide for common LWLogger usage patterns in Swift
//

import Foundation

/*

 QUICK START GUIDE
 =================

 1. INITIALIZATION
 -----------------
 Add this to your AppDelegate or App struct:

 ```swift
 import LWLogger

 // In AppDelegate
 func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     LWLogUtil.initLogConfig()
     return true
 }

 // Or in SwiftUI App
 @main
 struct MyApp: App {
     init() {
         LWLogUtil.initLogConfig()
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 }
 ```

 2. BASIC LOGGING
 ----------------
 ```swift
 // Simple message
 LWLog("This is a basic log message")

 // Different log levels (DEBUG builds only)
 LWLogVerbose("Detailed debugging info")
 LWLogDebug("Debug information")
 LWLogInfo("General information")
 LWLogWarn("Warning message")
 LWLogError("Error message")

 // With string interpolation
 let userName = "John"
 LWLog("User \(userName) logged in")
 ```

 3. LOGGING IN FUNCTIONS
 -----------------------
 ```swift
 func performTask() {
     LWLog("Starting task")

     // Your code here

     LWLog("Task completed")
 }
 ```

 4. ERROR LOGGING
 ----------------
 ```swift
 do {
     try someThrowingFunction()
     LWLogInfo("Operation succeeded")
 } catch {
     LWLogError("Operation failed: \(error.localizedDescription)")
 }
 ```

 5. NETWORK LOGGING
 ------------------
 ```swift
 func fetchData(from url: String) {
     LWLogInfo("Fetching data from: \(url)")

     // Network request...

     LWLogInfo("Response received")
 }
 ```

 6. EXPORT LOGS
 --------------
 ```swift
 // Get zip file path
 let zipPath = LWLogUtil.logZipPath()
 LWLog("Logs saved to: \(zipPath)")

 // Share the zip file
 let activityVC = UIActivityViewController(activityItems: [URL(fileURLWithPath: zipPath)],
                                           applicationActivities: nil)
 present(activityVC, animated: true)
 ```

 7. ADVANCED - ASYNC/AWAIT
 -------------------------
 ```swift
 @available(iOS 13.0, *)
 func exportLogsAsync() async {
     let zipPath = await LWLogUtil.logZipPathAsync()
     LWLog("Logs exported: \(zipPath)")
 }
 ```

 8. ADVANCED - COMBINE
 ---------------------
 ```swift
 @available(iOS 13.0, *)
 func exportLogsWithCombine() {
     LWLogUtil.logZipPathPublisher()
         .sink { path in
             LWLog("Logs exported: \(path)")
         }
         .store(in: &cancellables)
 }
 ```

 9. CUSTOM CONFIGURATION
 -----------------------
 ```swift
 // Custom logger configuration
 LWLogUtil.configureLogger(
     enableConsoleLogging: true,
     enableFileLogging: true,
     maxFileSize: 1024 * 1024 * 5,  // 5MB per file
     maxNumberOfLogFiles: 10,        // Keep 10 files
     rollingFrequency: 60 * 60 * 24  // Daily rotation
 )
 ```

 10. UTILITY METHODS
 -------------------
 ```swift
 // Get logs directory
 let logsDir = LWLogUtil.logsDirectory()

 // Get all log file paths
 let logPaths = LWLogUtil.logFilePaths()

 // Get count of log files
 let count = LWLogUtil.logFileCount()

 // Clear all logs
 LWLogUtil.clearAllLogs()
 ```

 11. SWIFTUI INTEGRATION
 -----------------------
 ```swift
 import SwiftUI

 struct ContentView: View {
     var body: some View {
         Button("Tap Me") {
             LWLog("Button was tapped")
         }
         .onAppear {
             LWLog("View appeared")
         }
     }
 }
 ```

 12. PROPERTY WRAPPER
 --------------------
 ```swift
 class MyClass {
     @Logged(name: "userName")
     var userName: String = ""  // Changes will be logged automatically
 }
 ```

 IMPORTANT NOTES:
 ================
 - Logs only work in DEBUG builds by default
 - In RELEASE builds, logging functions are no-ops (do nothing)
 - Log files rotate every 24 hours by default
 - Maximum 7 log files are kept by default
 - Logs are stored in the app's documents directory

 */

/// Quick start examples class
public class LWLoggerQuickStart {

    // This class exists only to provide documentation
    // All examples are in the comments above

    private init() {}
}
