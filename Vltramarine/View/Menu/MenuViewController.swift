//
//  MenuViewController.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: MenuViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = VltramarineFactory.makeMenuViewModel()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let menuCell = cell as! MenuCollectionViewCell
        menuCell.titleLabel.text = self.viewModel.items[indexPath.row].title
        menuCell.view.layer.borderWidth = 2.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedViewController = VltramarineFactory.makeFeedViewController()
        feedViewController.setContextWith(feed: Feed(feedTheme: self.viewModel.items[indexPath.row].feedTheme))
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }
    
    //-------------------------------------------------------------------------
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsCount = self.viewModel.items.count
        let rowsNumber = CGFloat(itemsCount / 2 + itemsCount % 2)
        
        return CGSize(width: self.collectionView!.frame.width/2, height: self.collectionView!.frame.height/rowsNumber)
    }
}
