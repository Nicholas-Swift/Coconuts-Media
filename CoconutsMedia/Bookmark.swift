//
//  Bookmark.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/14/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Bookmark: Object {
    
    dynamic var link = ""
    
    dynamic var city = ""
    
    // Small article
    dynamic var title = ""
    dynamic var meta = ""
    dynamic var imgUrl = ""
    dynamic var desc = ""
    
    // Full Article
    dynamic var heroImgUrl = ""
    dynamic var descKeys = ""
    dynamic var descValues = ""
}

class InitialCity: Object {
    dynamic var city = ""
}
