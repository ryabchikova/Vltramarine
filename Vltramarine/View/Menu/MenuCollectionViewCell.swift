//
//  MenuCollectionViewCell.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class MenuCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.backgroundColor = vltrmnLightGrayColor
        self.titleLabel.textColor = vltrmnDarkGrayColor
        self.titleLabel.font = vltrmnMenuItemFont
    }


}
