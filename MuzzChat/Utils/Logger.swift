//
//  Logger.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation

final class Logger {
    enum LogType: String {
        case debug = "✏️"
        case error = "🔴"
    }

    static func log(_ message: String, type: LogType = .debug, file: String = #file, function: String = #function) {
        #if DEBUG
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
                let filename = file.components(separatedBy: "/").last ?? ""
                print("\n" + type.rawValue + "\t\(filename) - \(function)\n" + type.rawValue + "\t\(message)")
            }
        #endif
    }
}
