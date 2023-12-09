//
//  AppLogger.swift
//  Custom Swift Logger
//
//  Created by Siddharth Kothari on 09/12/23.
//

import Foundation
import OSLog

struct AppLogger {
    
    static func log(tag: LogTag = .debug, _ items: Any...,
                file: String = #file,
                function: String = #function,
                line: Int = #line ,
                separator: String = " ") {

        let shortFileName = URL(string: file)?.lastPathComponent ?? "---"
        
        let output = items.map {
            if let item = $0 as? CustomStringConvertible {
                return "\(item.description)"
            } else {
                return "\($0)"
            }
        }
            .joined(separator: separator)
        
        var msg = "\(tag.label) "
        let category = "\(shortFileName) - \(function) - line \(line)"
        if !output.isEmpty { msg += "\n\(output)" }
        
         let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "--", category: category)
        
        switch tag {
            case .error   : logger.error("\(msg)")
            case .warning : logger.warning("\(msg)")
            case .success : logger.info("\(msg)")
            case .debug   : logger.debug("\(msg)")
            case .network : logger.info("\(msg)")
            case .simOnly : logger.info("\(msg)")
        }
    }
}
