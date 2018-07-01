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

fileprivate struct FeedItem {
    
    let url: URL
    let pubDate: String
    var isFavorite: Bool = false
}

class FeedViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feed: Feed!
    var photoService: PhotoService!
    
    private var items = [FeedItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
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
        
//        _ = self.photoService.getAllPhotosFrom(feed: feed).map { photos in
//            return photos.map { photo in
//                return FeedItem(url: photo.url, pubDate: photo.publicationDate.description, isFavorite: false)
//            }
//        }.done { feedItems in
//            self.items = feedItems
//        }
        
        // 2nd variant
        firstly {
            self.photoService.getAllPhotosFrom(feed: feed)
        }.map { photos in
            return photos.map { photo in
                return FeedItem(url: photo.url, pubDate: photo.publicationDate.description, isFavorite: false)
            }
        }.done { feedItems in
            self.items = feedItems
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
        return tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FeedTableViewCell
        // TODO activity indicator
        
        cell.feedImage.sd_setImage(with: self.items[indexPath.row].url, placeholderImage: UIImage(named: "default_image"))
        cell.pubDateLabel.text = self.items[indexPath.row].pubDate
    }
}
