//
//  ViewController.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {
    
    // Variables
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(ViewController.handleRefresh), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    var page = 0
    var pageWait = false
    
    var city: String? {
        didSet {
            navigationItem.title = city ?? "Coconuts Feed"
            setupNavigationItem()
        }
    }
    
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    var pullDownView: PulldownView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LOAD INITIAL CITY!!!
        self.city = BookmarkManager.initialCity
        
        navigationBarItem.title = city ?? "Coconuts Feed"
        //setupNavigationItem(up: true)
        
        // Set up style
        styleSetup()
        
        // Table View
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Pull to refresh to put everything in
        tableView.addSubview(refreshControl)
        
        // Get Articles
        getArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        super.viewWillAppear(animated)
        
        // Initialize the pullDownView
        if(pullDownView == nil) {
            pullDownView = PulldownView(frame: self.view.frame)
            pullDownView.delegate = self
            self.view.addSubview(pullDownView)
            
            // Send subviews to back
            self.view.sendSubview(toBack: pullDownView)
            self.view.sendSubview(toBack: tableView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    func getArticles() {
        // Get Articles
        APIHelper.getArticles(city: self.city?.lowercased(), complete: { (articles: [Article], error: NSError?) in
            if error == nil {
                self.articles = articles
            }
            else {
                print("ERROR: \(error)")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleSegue" {
            let sender = sender as! UITableViewCell
            let destination = segue.destination as! ShowArticleViewController
            let indexPath = tableView.indexPathForSelectedRow!
            
            destination.smallArticle = articles[indexPath.section]
            destination.city = self.city
            destination.link = articles[(tableView.indexPath(for: sender)?.section)!].link
        }
    }

}

// MARK: Table View

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let loadNew = scrollView.contentSize.height - scrollView.contentOffset.y
        if loadNew < 1000 && pageWait == false {
            pageWait = true
            self.page += 1
            APIHelper.getArticles(city: self.city?.lowercased(), pageNumber: self.page, complete: { (articles: [Article], error: NSError?) in
                self.pageWait = false
                if error == nil {
                    self.articles.append(contentsOf: articles)
                }
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == tableView.numberOfSections-1 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleTableViewCell
        cell.article = articles[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "ShowArticleSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
}

// MARK: Refresh
extension ViewController {
    
    func handleRefresh() {
        // Get Articles
        APIHelper.getArticles(city: self.city?.lowercased(), complete: { (articles: [Article], error: NSError?) in
            self.refreshControl.endRefreshing()
            if error == nil {
                self.articles = articles
            }
            else {
                print("ERROR: \(error)")
            }
        })
    }
    
}

// MARK: Style
extension ViewController {
    
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
        
        // Set up navigation item
        setupNavigationItem()
    }
    
    func titleTapped(sender: AnyObject) {
        pullDownView.tapped()
        
        //if(pullDownView.isUp) {
            (navigationBarItem.titleView as! NavigationLogoView).updateImage(up: !pullDownView.isUp)
        //}
    }
    
    func setupNavigationItem() {
        // Set up navigation item view
        let newLogoView = NavigationLogoView(city: self.city ?? "FUCK")
        navigationBarItem.titleView = newLogoView
        
        // Set up pull down tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleTapped(sender:)))
        navigationBarItem.titleView?.addGestureRecognizer(tap)
    }
}

// Pulldown View
extension ViewController: PulldownViewDelegate {
    func citySelected(city: String) {
        
        // Set initial city again
        BookmarkManager.initialCity = city
        
        // Load realm
        BookmarkManager.saveInitialCity(city: city)
        
        // Remove old stuff
        articles = []
        
        // Reset up
        self.city = city
        getArticles()
        
        // Pull pulldownView back up
        pullDownView.goUp()
    }
}

