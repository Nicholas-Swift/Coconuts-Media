//
//  Article.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation

class FullArticle {
    
    var title: String?
    var meta: String?
    var hero_img_url: String?
    var desc: [[String: String]]?
    
    var link: String?
    
    init(title: String, meta: String, hero_img_url: String, desc: [[String: String]], link: String) {
        self.title = title
        self.meta = meta
        self.hero_img_url = hero_img_url
        self.desc = desc
        self.link = link
    }
    
}
