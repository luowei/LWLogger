//
//  LWLogger+SwiftIntegration.swift
//  LWLogger
//
//  Swift-specific extensions and helpers for LWLogger
//

import Foundation
import CocoaLumberjack

// MARK: - Swift-friendly Extensions

extension LWLogUtil {

    /// Convenience method to get logs directory
    @objc public static func logsDirectory() -> String {
        let fileLogger = DDFileLogger()
        return fileLogger.logFileManager.logsDirectory
    }

    /// Convenience method to get all log file paths
    @objc public static func logFilePaths() -> [String] {
        let fileLogger = DDFileLogger()
        return fileLogger.logFileManager.sortedLogFilePaths
    }

    /// Get the count of existing log files
    @objc public static func logFileCount() -> Int {
        let fileLogger = DDFileLogger()
        return fileLogger.logFileManager.sortedLogFileNames.count
    }

    /// Clear all log files
    @objc public static func clearAllLogs() {
        let fileLogger = DDFileLogger()
        let logFilePaths = fileLogger.logFileManager.sortedLogFilePaths

        for path in logFilePaths {
            do {
                try FileManager.default.removeItem(atPath: path)
                LWLogInfo("Deleted log file: \(path)")
            } catch {
                LWLogError("Failed to delete log file: \(path), error: \(error)")
            }
        }
    }
}

// MARK: - Swift Result Type Integration

extension LWLogUtil {

    /// Log a Result type
    public static func log<T, E: Error>(_ result: Result<T, E>,
                                        successMessage: String = "Operation succeeded",
                                        context: String = "") {
        switch result {
        case .success:
            let message = context.isEmpty ? successMessage : "\(context): \(successMessage)"
            LWLogInfo(message)
        case .failure(let error):
            let message = context.isEmpty ? "Error: \(error)" : "\(context) - Error: \(error)"
            LWLogError(message)
        }
    }
}

// MARK: - Async/Await Support

@available(iOS 13.0, macOS 10.15, *)
extension LWLogUtil {

    /// Asynchronously create and return log zip path
    public static func logZipPathAsync() async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let path = logZipPath()
                continuation.resume(returning: path)
            }
        }
    }

    /// Asynchronously clear all logs
    public static func clearAllLogsAsync() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                clearAllLogs()
                continuation.resume()
            }
        }
    }
}

// MARK: - Combine Support

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, *)
extension LWLogUtil {

    /// Publisher for log zip creation
    public static func logZipPathPublisher() -> Future<String, Never> {
        Future { promise in
            DispatchQueue.global(qos: .utility).async {
                let path = logZipPath()
                promise(.success(path))
            }
        }
    }
}
#endif

// MARK: - Property Wrapper for Logged Properties

/// Property wrapper that logs when a value changes
@propertyWrapper
public struct Logged<T: CustomStringConvertible> {
    private var value: T
    private let name: String

    public init(wrappedValue: T, name: String) {
        self.value = wrappedValue
        self.name = name
        LWLogDebug("\(name) initialized with value: \(wrappedValue)")
    }

    public var wrappedValue: T {
        get { value }
        set {
            LWLogDebug("\(name) changed from \(value) to \(newValue)")
            value = newValue
        }
    }
}

// MARK: - Custom Log Formatters

/// Custom formatter for JSON-style logging
public class LWJSONLogFormatter: NSObject, DDLogFormatter {

    public func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = ISO8601DateFormatter().string(from: logMessage.timestamp)
        let level = logMessage.flag.description
        let file = URL(fileURLWithPath: logMessage.file).lastPathComponent
        let function = logMessage.function ?? "unknown"

        let json: [String: Any] = [
            "timestamp": timestamp,
            "level": level,
            "file": file,
            "function": function,
            "line": logMessage.line,
            "message": logMessage.message
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }

        return nil
    }
}

extension DDLogFlag {
    var description: String {
        switch self {
        case .error: return "ERROR"
        case .warning: return "WARN"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .verbose: return "VERBOSE"
        default: return "UNKNOWN"
        }
    }
}

// MARK: - Advanced Configuration

extension LWLogUtil {

    /// Configure logger with custom settings
    /// - Parameters:
    ///   - enableConsoleLogging: Enable console output
    ///   - enableFileLogging: Enable file logging
    ///   - maxFileSize: Maximum size per log file in bytes
    ///   - maxNumberOfLogFiles: Maximum number of log files to keep
    ///   - rollingFrequency: How often to create new log file (in seconds)
    @objc public static func configureLogger(enableConsoleLogging: Bool = true,
                                            enableFileLogging: Bool = true,
                                            maxFileSize: UInt64 = 1024 * 1024 * 2, // 2MB
                                            maxNumberOfLogFiles: UInt = 7,
                                            rollingFrequency: TimeInterval = 60 * 60 * 24) { // 24 hours

        // Console logging
        if enableConsoleLogging {
            DDLog.add(DDOSLogger.sharedInstance)
        }

        // File logging
        if enableFileLogging {
            let fileLogger = DDFileLogger()
            fileLogger.rollingFrequency = rollingFrequency
            fileLogger.logFileManager.maximumNumberOfLogFiles = maxNumberOfLogFiles
            fileLogger.maximumFileSize = maxFileSize
            DDLog.add(fileLogger)
        }
    }

    /// Add custom formatter to file logger
    @objc public static func addCustomFormatter(_ formatter: DDLogFormatter) {
        DDLog.allLoggers.forEach { logger in
            if let fileLogger = logger as? DDFileLogger {
                fileLogger.logFormatter = formatter
            }
        }
    }
}
