//
//  MenuViewController.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UICollectionViewController {
    
    private var viewModel: MenuViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = VltramarineFactory.makeMenuViewModel()
        self.navigationItem.title = "Photo feeds"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = vltrmnDarkGrayColor
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedViewController = VltramarineFactory.makeFeedViewController()
        let selectedItem = self.viewModel.items[indexPath.row]
        feedViewController.setContextWith(feed: Feed(feedTheme: selectedItem.feedTheme), screenTitle: selectedItem.title)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }

}
