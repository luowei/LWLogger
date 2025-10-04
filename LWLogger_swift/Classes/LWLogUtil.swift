//
//  LWLogUtil.swift
//  LWLogger
//
//  Swift implementation of LWLogUtil
//  Created by luowei on 2019/11/8.
//

import Foundation
import CocoaLumberjack

/// Logging utility class that wraps CocoaLumberjack functionality
/// Provides file-based logging with rotation and zip archive creation
@objc public class LWLogUtil: NSObject {

    // MARK: - Public Methods

    /// Initializes the logging configuration
    /// Sets up console logging and file logging with 24-hour rotation
    /// Keeps maximum of 7 log files
    @objc public static func initLogConfig() {
        // Add OS Logger (console output)
        DDLog.add(DDOSLogger.sharedInstance)

        // Add File Logger
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    /// Creates a zip archive of all log files
    /// - Returns: Path to the created zip file
    @objc public static func logZipPath() -> String {
        // Get DDLog log files
        let fileLogger = DDFileLogger()

        // Get log folder path
        let logDirectory = fileLogger.logFileManager.logsDirectory
        DDLogDebug(logDirectory)

        // Create zip file path
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let zipFileName = "/feedbackLog-\(dateFormatter.string(from: Date())).zip"
        let logZipPath = logDirectory + zipFileName

        // Get sorted log file names
        let logsNameArray = fileLogger.logFileManager.sortedLogFileNames
        DDLogDebug("\(logsNameArray)")

        // Create zip archive
        SSZipArchive.createZipFile(atPath: logZipPath, withFilesAtPaths: logsNameArray)

        return logZipPath
    }
}
