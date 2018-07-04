//
//  FullScreenPhotoViewController.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 04/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    @IBOutlet var photoImageView: UIImageView!
    var photoUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoImageView.sd_setImage(with: self.photoUrl, placeholderImage: UIImage(named: "default_image"))
    }
}
