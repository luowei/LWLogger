//
//  LWLoggerExample.swift
//  LWLogger
//
//  Example usage of LWLogger in Swift
//

import Foundation

/// Example class demonstrating LWLogger usage
public class LWLoggerExample {

    /// Initialize the logger - call this once at app startup
    public static func setup() {
        LWLogUtil.initLogConfig()
        LWLog("LWLogger initialized successfully")
    }

    /// Example: Basic logging at different levels
    public static func basicLoggingExample() {
        LWLogVerbose("This is a verbose message - lowest priority")
        LWLogDebug("This is a debug message - for debugging info")
        LWLogInfo("This is an info message - general information")
        LWLogWarn("This is a warning message - something to watch out for")
        LWLogError("This is an error message - something went wrong")
    }

    /// Example: Logging with variables
    public static func loggingWithVariables() {
        let userName = "John Doe"
        let userAge = 25

        LWLog("User logged in: \(userName), Age: \(userAge)")
        LWLogInfo("Processing data for user: \(userName)")
    }

    /// Example: Logging network requests
    public static func networkLoggingExample(url: String, statusCode: Int) {
        LWLogInfo("Network request to: \(url)")

        if statusCode == 200 {
            LWLogInfo("Request succeeded with status: \(statusCode)")
        } else {
            LWLogError("Request failed with status: \(statusCode)")
        }
    }

    /// Example: Logging with context
    public static func contextualLogging() {
        let context = [
            "userId": "12345",
            "sessionId": "abc-def-ghi",
            "timestamp": Date().description
        ]

        LWLogDebug("User action with context: \(context)")
    }

    /// Example: Export logs to zip file
    public static func exportLogsExample() -> String {
        let zipPath = LWLogUtil.logZipPath()
        LWLog("Logs exported to: \(zipPath)")
        return zipPath
    }

    /// Example: Error handling with logging
    public static func errorHandlingExample() {
        do {
            try performSomeOperation()
            LWLogInfo("Operation completed successfully")
        } catch {
            LWLogError("Operation failed: \(error.localizedDescription)")
        }
    }

    private static func performSomeOperation() throws {
        // Simulated operation
        let success = arc4random_uniform(2) == 0
        if !success {
            throw NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        }
    }
}

// MARK: - Usage in SwiftUI App

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, *)
public struct ExampleApp: App {
    public init() {
        // Initialize logger when app launches
        LWLogUtil.initLogConfig()
        LWLog("App launched")
    }

    public var body: some Scene {
        WindowGroup {
            LWLoggerView()
                .onAppear {
                    LWLog("Main view appeared")
                }
        }
    }
}
#endif

// MARK: - Usage in UIKit App

#if canImport(UIKit) && !os(watchOS)
import UIKit

@available(iOS 13.0, *)
public class ExampleAppDelegate: UIResponder, UIApplicationDelegate {

    public func application(_ application: UIApplication,
                           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Initialize logger
        LWLogUtil.initLogConfig()
        LWLog("Application did finish launching")

        // Log app information
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            LWLogInfo("App Version: \(appVersion)")
        }

        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            LWLogInfo("Build Number: \(buildNumber)")
        }

        return true
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        LWLog("Application will terminate")

        // Optional: Export logs before terminating
        let zipPath = LWLogUtil.logZipPath()
        LWLogInfo("Logs saved to: \(zipPath)")
    }
}
#endif
