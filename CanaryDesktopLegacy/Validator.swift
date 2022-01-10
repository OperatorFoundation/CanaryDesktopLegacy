//
//  Validator.swift
//  CanaryDesktopLegacy
//
//  Created by Mafalda on 10/19/21.
//

import Foundation
import Network

struct Validator
{
    static func validate(serverIP: String) -> Bool
    {
        var sin = sockaddr_in()
            return serverIP.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1
    }
    
    static func validate(configPath: String) -> Bool
    {
        let configURL = URL(fileURLWithPath: configPath)
        return validate(configURL: configURL)
    }
    
    static func validate(configURL: URL?) -> Bool
    {
        guard let isaURL = configURL
        else { return false }
        
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: isaURL.path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
}
