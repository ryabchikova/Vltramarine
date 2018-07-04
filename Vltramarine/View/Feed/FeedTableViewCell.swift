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
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var addToFavoritesButton: UIButton!
    
    weak var delegate: FeedTableViewCellDelegate?
    
    var isFavorite: Bool = false {
        didSet {
            self.addToFavoritesButton.isSelected = isFavorite
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pubDateLabel.textColor = vltrmnDarkGrayColor
        self.pubDateLabel.font = vltrmnDetailFont
        self.imageContainerView.layer.cornerRadius = 10.0
        self.imageContainerView.layer.borderWidth = 0.7
        self.imageContainerView.layer.borderColor = vltrmnLightGrayColor.cgColor
        
    }
    
    @IBAction func addToFavoritesAction(_ sender: Any) {
        delegate?.feedTableViewCellNeedChangeStateOn(newFavoriteState: !self.isFavorite, delegatedFrom: self)
    }
}
