//
//  LoggerClient.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//
import Foundation
import SwiftyBeaver

public struct LoggerClient {
    let logger = Logger()
    
    public init(enabled: Bool, minLevel: Level, usesNLog: Bool) {
        guard enabled else { return }
        let console = XcodeConsoleDestination()
        console.useNSLog = usesNLog
        console.minLevel = minLevel.value
        logger.instance.addDestination(console)
    }
    
    public func debug(
        _ items: Item...,
        context: Context? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        _print(items, .debug, context, file, line, function)
    }
    
    public func info(
        _ items: Item...,
        context: Context? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        _print(items, .info, context, file, line, function)
    }
    
    public func warning(
        _ items: Item...,
        context: Context? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        _print(items, .warning, context, file, line, function)
    }
    
    public func error(
        _ items: Item...,
        context: Context? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        _print(items, .error, context, file, line, function)
    }
    
    private func _print(
        _ items: [Item],
        _ level: Level,
        _ context: Context?,
        _ file: String,
        _ line: Int,
        _ function: String
    ) {
        func format(_ item: Item) -> String {
          item == nil ? "Nil" : "\(item.unsafelyUnwrapped)"
        }
        
        logger.instance.custom(
            level: level.value,
            message: items.map(format).joined(separator: " "),
            file: file,
            function: function,
            line: line,
            context: context?.value
        )
    }
}

extension LoggerClient {
    public typealias Item = Any?
    
    public enum Context: String {
        case app
        case ui
        case db
        case location
        case userDefaults = "user_defaults"
        case api
        case firebase
        case healthkit
    }
    
    public enum Level: Int {
        case verbose = 0
        case debug
        case info
        case warning
        case error
    }
}

extension LoggerClient.Level {
  var value: Logger.Instance.Level {
    .init(rawValue: rawValue) ?? .verbose
  }
}

extension LoggerClient.Context {
  public var value: String {
    "[" + rawValue.uppercased() + "]"
  }
}

#if RELEASE
public var Log = LoggerClient(enabled: false, minLevel: .info, usesNLog: true)
#else
public var Log = LoggerClient(enabled: true, minLevel: .debug, usesNLog: true)
#endif
