//
//  FeedViewController.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SDWebImage

// TODO перейти на использование Photo
fileprivate struct FeedItem {
    
    let identifier: Int
    let url: URL
    let publicationDate: String
    var isFavorite: Bool = false
}

class FeedViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feed: Feed!
    var photoService: PhotoService!
   
    private var items = [FeedItem]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchData()
    }
    
    private func fetchData() {
    
        firstly {
            self.photoService.getAllPhotosFrom(feed: feed)
        }.map { photos -> [FeedItem] in
            return photos.map { photo in
                return FeedItem(identifier: photo.identifier, url: photo.url, publicationDate: self.makeFormattedStringFrom(date: photo.publicationDate), isFavorite: photo.isFavorite)
            }
        }.done { feedItems in
            self.items = feedItems
            self.tableView.reloadData()
        }.catch { error in
            NSLog(error.localizedDescription)
            // TODO show error page
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        cell.delegate = self
        
        cell.feedImage.sd_setShowActivityIndicatorView(true)
        cell.feedImage.sd_setIndicatorStyle(.gray)
        cell.feedImage.sd_setImage(with: self.items[indexPath.row].url, placeholderImage: UIImage(named: "default_image"))
        
        cell.pubDateLabel.text = self.items[indexPath.row].publicationDate
        cell.isFavorite = self.items[indexPath.row].isFavorite
        
        return cell
    }
    
    // MARK: Helpers
    private func makeFormattedStringFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd MMM yyyy 'at' HH:mm:ss"
        return formatter.string(from: date)
    }
    
}

extension FeedViewController: FeedTableViewCellDelegate {
    
    func feedTableViewCellNeedChangeStateOn(newFavoriteState isFavorite: Bool, delegatedFrom cell: FeedTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            firstly {
                self.photoService.setFavoriteStateForPhotoWith(identifier: self.items[indexPath.row].identifier, isFavorite: isFavorite)
            }.done { executedWithSuccess in
                if executedWithSuccess {
                    self.items[indexPath.row].isFavorite = isFavorite
                    cell.isFavorite = isFavorite
                }
            }
        }
    }
}
