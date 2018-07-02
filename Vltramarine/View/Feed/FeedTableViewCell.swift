//
//  FeedTableViewCell.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class FeedTableViewCell : UITableViewCell {
    
    @IBOutlet var feedImage: UIImageView!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var addToFavoritesButton: UIButton!
    
    weak var delegate: FeedTableViewCellDelegate?
    
    var isFavorite: Bool = false {
        didSet {
            self.addToFavoritesButton.isSelected = isFavorite
        }
    }
    
    @IBAction func addToFavoritesAction(_ sender: Any) {
        let newState = !self.isFavorite
        delegate?.feedTableViewCellNeedChangeStateOn(newFavoriteState: newState, delegatedFrom: self)
    }
    
}
