//
//  VltramarineConfiguration.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 09/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

func getConfiguration(fromPlist fileName: String, in bundle: Bundle) -> [String: Any] {
    if let plistPath =  bundle.path(forResource: fileName, ofType: "plist") {
        if let plistXML = FileManager.default.contents(atPath: plistPath) {
            do {
                var propertyListForamt = PropertyListSerialization.PropertyListFormat.xml
                let plistData = try PropertyListSerialization.propertyList(from: plistXML, /*options: .mutableContainersAndLeaves,*/ format: &propertyListForamt) as! [String: Any]
                return plistData
            } catch {
                fatalError("Configuration plist reading error: \(error)")
            }
        }
    }
    return [:]
}
