//
//  ShowArticleVideoTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 11/15/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import Alamofire

class ShowArticleVideoTableViewCell: UITableViewCell {
    
    // Variables
    @IBOutlet weak var webView: UIWebView!
    var youtubeUrl: String? {
        didSet {
//            if let youtubeUrl = youtubeUrl {
//                let url = URL(string: youtubeUrl)
//                let urlRequest = URLRequest(url: url!)
//                self.webView.loadRequest(urlRequest)
//            }
        }
    }
    
    // Table View
    
    override func awakeFromNib() {
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        webView.layer.borderColor = ColorHelper.redditLightGrayColor.cgColor
        webView.layer.borderWidth = 0.5
    }
}
