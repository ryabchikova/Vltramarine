//
//  FeedXMLParser.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class FeedXMLParser: NSObject, XMLParserDelegate {
    
    var photosArray = [(url: String, pubDate: Date)]()
    
    var currentElementName = ""
    var currentElementText = ""
    
    var curentPhotoUrl = ""
    var curentPubDate = Date()

    func getAllPhotosFrom(feedUrl: String) -> [(url: String, pubDate: Date)] {
        guard let url = URL(string: feedUrl) else { return [] }
        guard let xmlParser = XMLParser(contentsOf: url) else { return [] }
        xmlParser.delegate = self
        
        self.photosArray = []
        return xmlParser.parse() ? self.photosArray : []
    }
    
    // MARK: XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.currentElementName == "description" || self.currentElementName == "pubDate" {
            self.currentElementText += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "description" {
            // cut off trash
            let fullText = self.currentElementText
            let firstRange = fullText.range(of: "src=\"")
            let secondRange = fullText.range(of: "\" /></a>")
            var trimmedText = ""
            if firstRange != nil && secondRange != nil {
                trimmedText = String(fullText[firstRange!.upperBound..<secondRange!.lowerBound])
            }
            
            self.curentPhotoUrl = trimmedText
            self.currentElementText = ""
            return
        }
        
        if elementName == "pubDate" {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
            if let pubDate = formatter.date(from: self.currentElementText) {
                self.curentPubDate = pubDate
            } else {
                self.curentPubDate = Date()
            }
            
            self.currentElementText = ""
            return
        }
        
        if elementName == "item" {
            self.photosArray.append((url: self.curentPhotoUrl, pubDate: self.curentPubDate))
        }
    }
}
