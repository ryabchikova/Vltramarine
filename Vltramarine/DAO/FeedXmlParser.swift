//
//  FeedXMLParser.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class FeedXMLParser: NSObject, XMLParserDelegate {
    
    var photosArray = [Photo]()
    
    var currentElementName = ""
    var currentElementText = ""
    
    var curentPhotoUrl = ""
    var curentPubDate = ""

    func getAllPhotosFrom(feedUrl: String) -> [Photo]? {
        guard let url = URL(string: feedUrl) else { return nil }
        guard let xmlParser = XMLParser(contentsOf: url) else { return nil }
        xmlParser.delegate = self
        
        self.photosArray = []
        
        let sucess = xmlParser.parse()
        return sucess ? self.photosArray : nil
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
            self.curentPubDate = self.currentElementText
            self.currentElementText = ""
            return
        }
        
        if elementName == "item" {
            if let photo = Photo(url: self.curentPhotoUrl, publicationDate: self.curentPubDate) {
                self.photosArray.append(photo)
            }
        }
    }
}
