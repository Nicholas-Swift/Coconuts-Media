//
//  Article.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation

class Article {
    
    var title: String?
    var meta: String?
    var img_url: String?
    var desc: String?
    var link: String?
    
    init(title: String, meta: String, img_url: String, desc: String, link: String) {
        self.title = title
        self.meta = meta
        self.img_url = img_url
        self.desc = desc
        self.link = link
    }
    
}
