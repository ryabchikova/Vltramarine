//
//  VltramarineError.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 01/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation


let kPhotoRepositoryErrorDomain = "PhotoRepository"


let kFeedXmlParserErrorDomain = "FeedXmlParser"

enum FeedXmlParserErrorCode: Int {
    case invalidDocumentUrl = 1
}
