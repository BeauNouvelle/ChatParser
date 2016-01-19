//
//  ChatParser.swift
//  ChatParser
//
//  Created by Beau Nouvelle on 16/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import Foundation

public struct ChatParser {
    
    public enum Content {
        case Mentions
        case Emoticons
        case Links
        case Any
    }
    
    public var prettyJSON: String?
    public var JSON: String?
    
    /**
     Parses chat text and pulls out any combination of @username's, (emoticons), links and web page titles.
     - parameter content: The type of content you wish to extract.
     - parameter string: The `string` you wish to extract the content from.
     - returns: A string in JSON format.
    */
    public init(extractContent content: Content..., fromString string: String) {
        
        var jsonDictionary = [String:AnyObject]()
        
        if content.contains([.Mentions, .Any].contains) {
            if let mentions = extractMentions(fromString: string) {
                jsonDictionary["mentions"] = mentions
            }
        }
        if content.contains([.Emoticons, .Any].contains) {
            if let emoticons = extractEmoticons(fromString: string) {
                jsonDictionary["emoticons"] = emoticons
            }
        }
        if content.contains([.Links, .Any].contains) {
            if let links = extractWebData(fromString: string) {
                print(links)
                jsonDictionary["links"] = links
            }
        }
        
        prettyJSON = jsonDictionary.prettyJSON    // Pretty format to match the brief.
        JSON = jsonDictionary.JSON                // another for good luck.
    }

    // MARK: - Private Functions -
    /**
     Extracts all mentions found in a given string that are prefixed with an @ symbol. eg. @beaunouvelle
     - parameter string: The `string` you wish to extract a list of mentions from.
     - returns: An `array` of extracted strings matching the @username format.
    */
    private func extractMentions(fromString string: String) -> [String]? {
        let regexPattern = "\\B@([a-z0-9_-]+)"
        let mentions = performRegexOnString(string, withPattern: regexPattern)

        return mentions?.count > 0 ? mentions : nil
    }
    
    /**
     Extracts any words in a given string that are encapsulated by parenthesis. eg. "(megusta)"
     - parameter string: The `string` you wish to extract a list of emoticons from.
     - returns: An `array` of extracted strings matching the (emoticon) format.
     */
    private func extractEmoticons(fromString string: String) -> [String]? {
        let regexPattern = "\\(([^\\s][^\\)]+)\\)"
        let emoticons = performRegexOnString(string, withPattern: regexPattern)
        
        return emoticons?.count > 0 ? emoticons : nil
    }
    
    /**
     Extracts any webpage links found in a given string including the page titles for each link.
     - parameter string: 
     - returns: An 'array' of dictionary objects containing both a webpage link and webpage title if it can be found.
    */
    private func extractWebData(fromString string: String) -> [[String:AnyObject]]? {
        let regexPattern = "\\b((?:https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|])"
        var links = [[String:AnyObject]]()
        
        guard let urls = performRegexOnString(string, withPattern: regexPattern) where urls.count > 0 else {
            return nil
        }
        
        for url in urls {
            
            var linkContent = [String:AnyObject]()
            linkContent["url"] = url

            do {
                let htmlString = try String(contentsOfURL: NSURL(string: url)!, encoding: NSASCIIStringEncoding)
                let pageTitle = extractPageTitle(htmlString)
                print(pageTitle)
                linkContent["title"] = pageTitle
            } catch {
                // TODO: Work out requirements for what happens when we can't load a URL. 
                // Currently only the link will be returned for that url. No title if it won't load.
            }
            links.append(linkContent)
        }
        return links
    }
    
    /**
     Extracts a title (if it exists) from a string of html content.
     - parameter html: The html string you wish to extract the title from.
     - returns: The page title if one is found, otherwise returns nil.
    */
    private func extractPageTitle(html: NSString) -> String? {
        let start = "<title>"
        let end = "</title>"
        
        let startRange = NSString(string: html).rangeOfString(start)
        let endRange = NSString(string: html).rangeOfString(end)
        
        guard startRange.location != NSNotFound else {
            return nil
        }

        let substring = html.substringWithRange(NSMakeRange(startRange.location + 7, endRange.location - startRange.location - 7))
        let trimmedString = substring.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        return trimmedString
    }
    
    // MARK: Regex
    private func performRegexOnString(string: String, withPattern pattern: String) -> [String]? {
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
            return nil
        }
        return results.count > 0 ? results : nil
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