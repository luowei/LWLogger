//
//  LWLogger.swift
//  LWLogger
//
//  Swift implementation of LWLogger
//  Main logging interface
//

import Foundation
import CocoaLumberjack

// MARK: - Global Log Level Configuration

/// Global log level for the application
public let ddLogLevel: DDLogLevel = .all

// MARK: - Logging Functions

#if DEBUG
/// Debug-only logging function that logs at info level
/// In release builds, this function does nothing
/// - Parameters:
///   - message: The message to log
///   - file: Source file (auto-filled)
///   - function: Function name (auto-filled)
///   - line: Line number (auto-filled)
public func LWLog(_ message: @autoclosure () -> String,
                  file: StaticString = #file,
                  function: StaticString = #function,
                  line: UInt = #line) {
    DDLogInfo(message(), file: file, function: function, line: line)
}

/// Debug-only logging function for verbose messages
public func LWLogVerbose(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {
    DDLogVerbose(message(), file: file, function: function, line: line)
}

/// Debug-only logging function for debug messages
public func LWLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    DDLogDebug(message(), file: file, function: function, line: line)
}

/// Debug-only logging function for info messages
public func LWLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    DDLogInfo(message(), file: file, function: function, line: line)
}

/// Debug-only logging function for warning messages
public func LWLogWarn(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    DDLogWarn(message(), file: file, function: function, line: line)
}

/// Debug-only logging function for error messages
public func LWLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    DDLogError(message(), file: file, function: function, line: line)
}

#else
// Release builds - no-op logging functions
public func LWLog(_ message: @autoclosure () -> String,
                  file: StaticString = #file,
                  function: StaticString = #function,
                  line: UInt = #line) {}

public func LWLogVerbose(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {}

public func LWLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {}

public func LWLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {}

public func LWLogWarn(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {}

public func LWLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {}
#endif
