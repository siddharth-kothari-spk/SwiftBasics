//
//  LogTag.swift
//  Custom Swift Logger
//
//  Created by Siddharth Kothari on 09/12/23.
//

import Foundation

// enum describing all the possible types of events that we want to log

enum LogTag {
    
    case error
    case warning
    case success
    case debug
    case network
    case simOnly
    
    var label: String {
        switch self {
        case .error   : return "[APP ERROR 🔴]"
        case .warning : return "[APP WARNING 🟠]"
        case .success : return "[APP SUCCESS 🟢]"
        case .debug   : return "[APP DEBUG 🔵]"
        case .network : return "[APP NETWORK 🌍]"
        case .simOnly : return "[APP SIMULATOR ONLY 🤖]"
        }
    }
}
