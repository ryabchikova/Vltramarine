//
//  FeedTableViewCellDelegate.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 02/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

protocol FeedTableViewCellDelegate: class {
    
    func feedTableViewCellNeedChangeStateOn(newFavoriteState isFavorite: Bool, delegatedFrom cell: FeedTableViewCell)
}
