//
//  ViewController.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import AlamofireImage

class ShowArticleViewController: UIViewController {
    
    // Variables
    
    var city: String? {
        didSet {
            navigationItem.title = city ?? "Coconuts Feed"
        }
    }
    
    var link: String? {
        didSet {
            APIHelper.showArticle(city: self.city?.lowercased(), link: self.link!) { (article: FullArticle?, error: NSError?) in
                if error == nil {
                    if let article = article {
                        self.article = article
                        self.tableView.reloadData()
                    }
                }
                else {
                    print("ERROR: \(error)")
                }
            }
            
        }
    }
    
    var smallArticle: Article!
    
    var article: FullArticle? {
        didSet {
            if(tableView == nil) {
                return
            }
            tableView.reloadData()
        }
    }
    
    // Bookmarking
    var isBookmarked = false
    
    // scrolling
    var firstPosition: CGFloat? = 0
    var lastOffsetY: CGFloat = 0
    var tics: Int = 0
    var navFrame: CGRect!
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topRightTabBarButton: UIBarButtonItem!
    
    // UI Actions
    
    @IBAction func topRightTabBarAction(_ sender: Any) {
        updateBookmark()
    }
    
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Controller
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // Table View
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        
        // Fix for nav bar hiding swipe back
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // Nav bar top right button
        bookmarkInit()
        
        // Nav bar
        navFrame = navigationController?.navigationBar.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        super.viewWillAppear(animated)
        
        // reset nav frame
        navigationController?.navigationBar.frame = navFrame
        
        // Reset nav color
        let color = UIColor.black
        navigationController?.navigationBar.tintColor = color
        let textAttributes: [String: Any] = [NSForegroundColorAttributeName: color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: Scrolling Down
extension ShowArticleViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        tics += 1
//        if tics >= 10 {
//            tics = 0
//            let hide = scrollView.contentOffset.y > self.lastOffsetY
//            
//            self.navigationController?.setNavigationBarHidden(hide, animated: true)
//        }
//    }
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        lastOffsetY = scrollView.contentOffset.y
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // If no first position, return, don't waste time
        guard let firstPosition = firstPosition else {
            return
        }
        
        // Is at min, top
        let isAtMin = scrollView.contentOffset.y
        if isAtMin < 80 {
            return
        }
        
        // Is at max, bottom
        let isAtMax = scrollView.contentOffset.y + scrollView.bounds.height - tableView.contentSize.height + 80
        if isAtMax > 0 {
            return
        }
        
        // Create new position
        var newPosition = firstPosition - scrollView.contentOffset.y
        newPosition = newPosition / 4
        
        // Take away from old position
        self.firstPosition = firstPosition - newPosition
        
        // Add to nav bar
        updateNavBar(newPosition: newPosition)
        updateView(newPosition: newPosition)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // Is at min, top
        
        let isAtMin = scrollView.contentOffset.y
        if isAtMin < 80 {
            firstPosition = nil
            return
        }
        
        // Is at max, bottom
        let isAtMax = scrollView.contentOffset.y + scrollView.bounds.height - tableView.contentSize.height + 80
        if isAtMax > 0 {
            firstPosition = nil
            return
        }
        
        firstPosition = scrollView.contentOffset.y
    }
    
    // Helpers
    
    func updateNavBar(newPosition: CGFloat) {
        
        if(navigationController == nil) {
            return
        }
        
        navigationController?.navigationBar.frame.origin.y = (navigationController?.navigationBar.frame.origin.y)! + newPosition
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let belowHeight: CGFloat = -(navigationController?.navigationBar.frame.size.height)! + statusBarHeight
        if (navigationController?.navigationBar.frame.origin.y)! < belowHeight {
            navigationController?.navigationBar.frame.origin.y = belowHeight
        }
        
        // Not over status bar bottom
        let overHeight = statusBarHeight
        if (navigationController?.navigationBar.frame.origin.y)! > overHeight {
            navigationController?.navigationBar.frame.origin.y = overHeight
        }
        
        // Calculate color and alpha
        let numerator = abs(belowHeight - (navigationController?.navigationBar.frame.origin.y)!)
        let denominator = overHeight - belowHeight
        
        let alpha = numerator / denominator
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        
        navigationController?.navigationBar.tintColor = color
        let textAttributes: [String: Any] = [NSForegroundColorAttributeName: color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func updateView(newPosition: CGFloat) {

        if(navigationController == nil) {
            return
        }
        
        // New origin
        view.frame.origin.y = view.frame.origin.y + newPosition
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // Not below height
        let belowHeight: CGFloat = statusBarHeight
        if(view.frame.origin.y < belowHeight) {
            view.frame.origin.y = belowHeight
        }
        
        // Not over 0
        let overHeight = statusBarHeight + (navigationController?.navigationBar.frame.height)!
        if (view.frame.origin.y > overHeight) {
            view.frame.origin.y = overHeight
        }
        
        updateViewSize(newPosition: newPosition)
    }
    
    func updateViewSize(newPosition: CGFloat) {
        
        // New frame
        var newFrame = view.frame
        newFrame.size.height = newFrame.size.height - newPosition
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let maxSize = UIScreen.main.bounds.height - statusBarHeight
        let minSize = maxSize - (navigationController?.navigationBar.frame.height)!
        
        if newFrame.size.height > maxSize {
            newFrame.size.height = maxSize
        }
        else if newFrame.size.height < minSize {
            newFrame.size.height = minSize
        }
        
        view.frame = newFrame
    }
    
}

// MARK: Nav bar
extension ShowArticleViewController: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
}

//MARK: Table View

extension ShowArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.article != nil {
            return (2 + (article?.desc?.count)!)
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 5
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections-1 {
            return 40
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ShowArticleVideoTableViewCell {
            cell.youtubeUrl = self.article?.desc?[indexPath.row - 2]["video"] ?? ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For initial SmallArticle
        guard let article = article else {
            
            switch(indexPath.row) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleTitleCell") as! ShowArticleTitleTableViewCell
                cell.titleLabel.text = smallArticle.title?.uppercased()
                return cell
                
            // Image - Working
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleImageCell") as! ShowArticleImageTableViewCell
                cell.imgView.af_setImage(withURL: URL(string: (smallArticle.img_url)!)!)
                return cell
                
            // Default
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleTextCell") as! ShowArticleTextTableViewCell
                cell.textLabel?.text = ""
                return cell
            }
            
        }
        
        switch(indexPath.row) {
            // Title - Working
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleTitleCell") as! ShowArticleTitleTableViewCell
            cell.titleLabel.text = article.title?.uppercased()
            return cell
            
            // Image - Working
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleImageCell") as! ShowArticleImageTableViewCell
            cell.imgView.af_setImage(withURL: URL(string: (article.hero_img_url)!)!)
            return cell
            
            // Default, text -> text, image, video
        default:
            let row = indexPath.row - 2
            
            // Text - Working
            if (article.desc?[row].keys.contains("text"))! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleTextCell") as! ShowArticleTextTableViewCell
                cell.string = article.desc?[row]["text"] ?? ""
                return cell
            }
            
            // Image - Working
            else if (article.desc?[row].keys.contains("img"))! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleImageCell") as! ShowArticleImageTableViewCell
                cell.imgView.image = nil // Reset image
                cell.imgUrl = article.desc?[row]["img"]
                return cell
            }
                
            // Video - Working
            else if (article.desc?[row].keys.contains("video"))! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleVideoCell") as! ShowArticleVideoTableViewCell
                
                let youtubeUrl = article.desc?[row]["video"] ?? ""
                let url = URL(string: youtubeUrl)
                let urlRequest = URLRequest(url: url!)
                cell.webView.loadRequest(urlRequest)
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowArticleTextCell")
                return cell!
            }
        }
    }
    
    func helpText(text: String) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes: [String: Any] = [NSParagraphStyleAttributeName: paragraphStyle]
        
        let attrString = NSAttributedString(string: text, attributes: attributes)
//        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        return attrString
        
    }
    
}

// MARK: Bookmarks
extension ShowArticleViewController {
    
    func bookmarkInit() {
        
        if let article = article {
            isBookmarked = BookmarkManager.isBookmark(link: article.link!)
        }
        else {
            isBookmarked = BookmarkManager.isBookmark(link: smallArticle.link!)
        }
        
        visuallyUpdateBookmark()
        
    }
    
    func visuallyUpdateBookmark() {
        topRightTabBarButton.image = isBookmarked ? UIImage(named: "Bookmark Ribbon Filled Nav") : UIImage(named: "Bookmark Ribbon Nav")
    }
    
    func updateBookmark() {
        
        guard let article = article else {
            return
        }
        
        isBookmarked = !isBookmarked
        
        // Update bookmark manager
        
        if isBookmarked {
            BookmarkManager.addBookmark(link: smallArticle.link!, city: self.city!, article: smallArticle, fullArticle: article)
        }
        else {
            BookmarkManager.removeBookmark(link: article.link!)
        }
        
        // Visually update
        visuallyUpdateBookmark()
    }
    
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
