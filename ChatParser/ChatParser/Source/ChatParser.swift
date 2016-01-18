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
        let regexPattern = "\\B@([a-z0-9_-]+)"
        let mentions = performRegexOnString(string, withPattern: regexPattern)

        return mentions.count > 0 ? mentions : nil
    }
    
    private func extractEmoticons(fromString string: String) -> [String]? {
        let regexPattern = "\\(([^\\s][^\\)]+)\\)"
        let emoticons = performRegexOnString(string, withPattern: regexPattern)
        
        return emoticons.count > 0 ? emoticons : nil
    }
    
    private func extractLinks(fromString string: String) -> [[String:AnyObject]] {
        let regexPattern = "\\b((?:https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|])"
        let urls = performRegexOnString(string, withPattern: regexPattern)
        
        // call url, in response get title then return appropriate result.
        print(urls)
        
        return [["url": "http://www.nbcolympics.com","title": "NBC Olympics | 2014 NBC Olympics in Sochi Russia"]]
    }
    
    // MARK: Regex
    private func performRegexOnString(string: String, withPattern pattern: String) -> [String]! {
        var results = [String]()

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: [], range: NSMakeRange(0, string.characters.count))
            
            for match in matches {
                let range = match.rangeAtIndex(1)
                if let swiftRange = rangeFromNSRange(range, forString: string) {
                    results.append(string.substringWithRange(swiftRange))
                }
            }
        } catch {
            // regex was bad!
        }
        return results
    }
    
    private func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        return nil
    }
    
}