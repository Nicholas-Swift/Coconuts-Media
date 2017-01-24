//
//  BookmarkTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/9/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    // Variables
    
    var article: Article? {
        didSet {
            titleLabel.text = article?.title?.uppercased()
            setupLineSpacing(string: article?.desc ?? "")
            setupMeta(metaString: article?.meta ?? "")
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
 
    // Helpers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLineSpacing(string: "")
    }
    
    func setupCell(article: Article) {
        self.article = article
    }
    
    func setupLineSpacing(string oldString: String) {
        
        var string = oldString
        if oldString.characters.count > 90 {
            let endIndex = string.index(string.startIndex, offsetBy: 90)
            string = string.substring(to: endIndex) + "..."
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
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
        
        authorLabel.text = author.joined(separator: " ")
        dateLabel.text = date.joined(separator: " ")
    }
    
}
