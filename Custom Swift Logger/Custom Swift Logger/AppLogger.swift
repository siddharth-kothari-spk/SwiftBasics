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

        // the filename where the log started is created here
        let shortFileName = URL(string: file)?.lastPathComponent ?? "---"
        
        // you create the output of the things you need to log. You can also pass objects conforming to the CustomStringConvertible protocol.
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
        
        // here we use the new Logger made by Apple. It just adds your bundle id in the subsystem . You will need it later in the console. For the field category I’ve used the infos of the calling function
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
