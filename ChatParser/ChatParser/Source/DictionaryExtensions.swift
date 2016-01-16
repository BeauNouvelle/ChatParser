//
//  DictionaryExtensions.swift
//  ChatParser
//
//  Created by Beau Young on 17/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
    
    var jsonString: String? {
        if let dict = (self as? AnyObject) as? Dictionary<String, AnyObject> {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: UInt.allZeros))
                if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
}