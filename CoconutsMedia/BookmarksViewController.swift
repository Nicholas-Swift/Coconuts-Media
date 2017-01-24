//
//  BookmarksViewController.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/10/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    // Variables
    
    var articles: [Article] = []
    
    // UI Elements
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBookmarksLabel: UILabel!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup style
        styleSetup()
        
        // Table View
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        super.viewWillAppear(animated)
        
        // Setup articles and reload data
        articles = BookmarkManager.bookmarks.values.map{$0}
        tableView.reloadData()
        
        noBookmarksLabel.isEnabled = articles.isEmpty
        noBookmarksLabel.isHidden = !articles.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ShowArticleViewController
        let indexPath = tableView.indexPathForSelectedRow!
        
        let link = articles[indexPath.section].link!
        destination.city = BookmarkManager.citiesBookmark[link]
        destination.smallArticle = BookmarkManager.bookmarks[link]
        destination.article = BookmarkManager.fullBookmarks[link]
    }
    
}

// MARK: TableView

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BookmarkManager.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell") as! BookmarkTableViewCell
        cell.setupCell(article: articles[indexPath.section])
        return cell
    }
    
}

// MARK: Style
extension BookmarksViewController {
    
    func styleSetup() {
        // Set up Tab Bar style
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = ColorHelper.redditLightGrayColor.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController?.tabBar.isTranslucent = false
        
        // Set up Nav Bar style
        navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.black
    }
    
}
