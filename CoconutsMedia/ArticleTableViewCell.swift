//
//  ArticleTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // Variables
    
    var article: Article? {
        didSet {
            titleLabel.text = article?.title?.uppercased()
            imgView.af_setImage(withURL: URL(string: article?.img_url ?? "")!)
            setupLineSpacing(string: article?.desc ?? "")
            setupMeta(metaString: article?.meta ?? "")
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var metaAuthor: UILabel!
    @IBOutlet weak var metaDate: UILabel!
    
    // Table View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLineSpacing(string: "")
        imgView.layer.borderColor = ColorHelper.redditLightGrayColor.cgColor
        imgView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.af_cancelImageRequest()
        imgView.image = nil
    }
    
    // Helpers
    
    func setupCell(article: Article) {
        self.article = article
    }
    
    func setupLineSpacing(string: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.attributedText = attrString
    }
    
    func setupMeta(metaString: String) {
        let meta = metaString.characters.split{$0 == " "}.map(String.init)
        var author: [String] = []
        var date: [String] = []
        
        var addToDate = false
        for (index, element) in meta.enumerated() {
            if (index == 0) {
                continue
            }
            
            if(!addToDate) {
                for i in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] {
                    if element.hasPrefix(i) {
                        addToDate = true
                    }
                }
            }
            
            if(!addToDate) {
                author.append(element)
            }
            else {
                date.append(element)
            }
        }
        
        metaAuthor.text = author.joined(separator: " ")
        metaDate.text = date.joined(separator: " ")
    }
    
}
