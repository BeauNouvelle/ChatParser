//
//  ChatParser.swift
//  ChatParser
//
//  Created by Beau Nouvelle on 16/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import Foundation

class ChatParser {
    
    enum Content {
        case Mentions
        case Emoticons
        case Links
        case Any
    }
    
    class func extractContent(content: Content..., fromString string: String) -> String? {
        
        var jsonDictionary = [String:AnyObject]()
        
        if content.contains([.Mentions, .Any].contains) {
            jsonDictionary["mentions"] = extractMentions(fromString: string)
        }
        if content.contains([.Emoticons, .Any].contains) {
            jsonDictionary["emoticons"] = extractEmoticons(fromString: string)
        }
        if content.contains([.Links, .Any].contains) {
            jsonDictionary["links"] = extractLinks(fromString: string)
        }
        return jsonDictionary.jsonString
    }
    
    
    private class func extractMentions(fromString string: String) -> [String] {
        return ["chris"]
    }
    
    private class func extractEmoticons(fromString string: String) -> [String] {
        return ["megusta","coffee"]
    }
    
    private class func extractLinks(fromString string: String) -> [[String:AnyObject]] {
        return [["url": "http://www.nbcolympics.com","title": "NBC Olympics | 2014 NBC Olympics in Sochi Russia"]]
    }
    
    
}