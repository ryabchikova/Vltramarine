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

class FeedViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var feed: Feed!
    private var items = [PhotoViewModel]()
    var photoService: PhotoService!
    
    @IBOutlet var tableView: UITableView!
    
    func setContextWith(feed: Feed, screenTitle: String) {
        self.feed = feed
        self.navigationItem.title = screenTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        // TODO copypaste!!!
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = vltrmnDarkGrayColor
        
        self.fetchData()
    }
    
    private func fetchData() {
        firstly {
            self.photoService.getAllPhotosFrom(feed: self.feed)
        }.map { photos -> [PhotoViewModel] in
            return photos.map { photo in
                return PhotoViewModel(photo)
            }
        }.done { feedItems in
            self.items = feedItems
            self.tableView.reloadData()
        }.catch { error in
            let error = error as NSError
            NSLog("Fetching feed data failed. Error domain: %@ code: %d description: %@", error.domain, error.code, error.localizedDescription)
            self.showFetchErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func showFetchErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Loading data error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fullScreenPhotoViewController = VltramarineFactory.makeFullScreenPhotoViewController()
        fullScreenPhotoViewController.photoUrl = self.items[indexPath.row].url
        self.navigationController?.pushViewController(fullScreenPhotoViewController, animated: true)
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
