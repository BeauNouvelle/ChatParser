//
//  ChatParser.swift
//  ChatParser
//
//  Created by Beau Nouvelle on 16/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import Foundation

struct ChatParser {
    
    enum Content {
        case Mentions
        case Emoticons
        case Links
        case Any
    }
    
    /**
     
    */
    func extractContent(content: Content..., fromString string: String) -> String? {
        
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
    
    
    private func extractMentions(fromString string: String) -> [String]? {
        let words = string.componentsSeparatedByString(" ")
        var mentions = [String]()
        
        for word in words.filter({$0.hasPrefix("@")}) {
            mentions.append(String(word.characters.dropFirst()))
        }
        return mentions.count > 0 ? mentions : nil
    }
    
    private func extractEmoticons(fromString string: String) -> [String]? {
        let searchPattern = "\\(([^\\s][^\\)]+)\\)"
        var emoticons = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: searchPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: [], range: NSMakeRange(0, string.characters.count))
            
            for match in matches {
                let range = match.rangeAtIndex(1)
                if let swiftRange = rangeFromNSRange(range, forString: string) {
                    emoticons.append(string.substringWithRange(swiftRange))
                }
            }
        } catch {
            // regex was bad!
        }
        return emoticons
    }
    
    func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }
    
    private func extractLinks(fromString string: String) -> [[String:AnyObject]] {
        return [["url": "http://www.nbcolympics.com","title": "NBC Olympics | 2014 NBC Olympics in Sochi Russia"]]
    }
    
}