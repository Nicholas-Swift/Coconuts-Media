//
//  ShowArticleTextTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ShowArticleTextTableViewCell: UITableViewCell {
    
    var string: String! {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
            
            let attrString = NSAttributedString(string: string, attributes: attributes)
            
            descLabel.numberOfLines = 0
            descLabel.lineBreakMode = .byWordWrapping
            descLabel.attributedText = attrString
        }
    }
    
    // Variables
    
    @IBOutlet weak var descLabel: UILabel!
    
    // Table View
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.descLabel.preferredMaxLayoutWidth = self.frame.width - 32
//    }
}
