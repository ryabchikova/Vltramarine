//
//  FeedXMLParser.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class FeedXMLParser: NSObject, XMLParserDelegate {
    
    private var photosArray = [Photo]()
    
    private var currentElementName = ""
    private var currentElementText = ""
    
    private var currentDescription = ""
    private var currentPubDate = ""

    func getAllPhotosFrom(feedUrl: String) throws -> [Photo] {
        guard let url = URL(string: feedUrl) else {
            throw NSError(domain: kFeedXmlParserErrorDomain, code: FeedXmlParserErrorCode.invalidDocumentUrl.rawValue, userInfo:  [NSLocalizedDescriptionKey: "Bad url: '\(feedUrl)'"])
        }
        guard let xmlParser = XMLParser(contentsOf: url) else {
            throw NSError(domain: kFeedXmlParserErrorDomain, code: FeedXmlParserErrorCode.invalidDocumentUrl.rawValue, userInfo:  [NSLocalizedDescriptionKey: "Bad url: '\(url)'"])
        }
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
            self.currentDescription = self.currentElementText
            self.currentElementText = ""
            return
        }
        
        if elementName == "pubDate" {
            self.currentPubDate = self.currentElementText
            self.currentElementText = ""
            return
        }
        
        if elementName == "item" {
            let fetchedUrl = self.fetchUrlFrom(self.currentDescription)
            let fetchedIdentifier = (fetchedUrl != nil) ? self.fetchIdentifierFrom(fetchedUrl!.absoluteString) : nil
            let fetchedDate = self.fetchDateFrom(self.currentPubDate)
            
            if let url = fetchedUrl, let identifier = fetchedIdentifier, let date = fetchedDate {
                self.photosArray.append(Photo(identifier: identifier, url: url, publicationDate: date))
            }
        }
    }
    
    // MARK: Helpers
    
    private func fetchUrlFrom(_ text: String) -> URL? {
        let firstRange = text.range(of: "src=\"")
        let secondRange = text.range(of: "\" /></a>")
        if firstRange != nil && secondRange != nil {
            return URL(string: String(text[firstRange!.upperBound..<secondRange!.lowerBound]))
        }
        
        return nil
    }
    
    private func fetchIdentifierFrom(_ url: String) -> Int? {
        let firstRange = url.range(of: "photos/")
        let secondRange = url.range(of: "/images")
        if firstRange != nil && secondRange != nil {
            return (String(url[firstRange!.upperBound..<secondRange!.lowerBound]) as NSString).integerValue
        }
        
        return nil
    }
    
    private func fetchDateFrom(_ text: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        return formatter.date(from: text)
    }
    
}
