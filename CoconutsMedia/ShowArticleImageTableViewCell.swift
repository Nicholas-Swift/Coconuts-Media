//
//  ShowArticleImageTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ShowArticleImageTableViewCell: UITableViewCell {
    
    // Variables
    
    var imgUrl: String? {
        didSet {
            imgView.af_setImage(withURL: URL(string: imgUrl ?? "")!)
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var imgView: UIImageView!
    
    // Table View
    
    override func awakeFromNib() {
        imgView.layer.borderColor = ColorHelper.redditLightGrayColor.cgColor
        imgView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        imgView.af_cancelImageRequest()
    }
}
