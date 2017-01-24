//
//  BookmarkManager.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/9/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BookmarkManager {
    
    static var initialCity: String!
    
    static var citiesBookmark: [String: String] = [:]
    static var bookmarks: [String: Article] = [:]
    static var fullBookmarks: [String: FullArticle] = [:]
    
    static func addBookmark(link: String, city: String, article: Article, fullArticle: FullArticle) {
        
        // Set up stuff
        citiesBookmark[link] = city
        bookmarks[link] = article
        fullBookmarks[link] = fullArticle
        
        // Save to core data
        saveItemToCoreData(city: city, article: article, fullArticle: fullArticle)
    }
    
    static func removeBookmark(link: String) {
        
        // Remove stuff
        citiesBookmark[link] = nil
        bookmarks[link] = nil
        fullBookmarks[link] = nil
        
        // Delete from core data
        deleteItemFromCoreData(link: link)
    }
    
    static func isBookmark(link: String) -> Bool {
        return bookmarks[link] == nil ? false : true
    }
    
}

// MARK: Persistence

extension BookmarkManager {
    
//    static func saveToCoreData() {
//        
//        // Create a realm
//        let realm = try! Realm()
//        
//        // Create all the objects
//        var realmBookmarks: [Bookmark] = []
//        let citiesItems: [String] = citiesBookmark.values.map{$0}
//        let smallItems: [Article] = bookmarks.values.map{$0}
//        let fullItems: [FullArticle] = fullBookmarks.values.map{$0}
//        
//        // Create all bookmarks
//        for i in 0..<bookmarks.count {
//            
//            // Create bookmarks
//            let newBookMark = Bookmark()
//            
//            newBookMark.link = smallItems[i].link!
//            
//            newBookMark.city = citiesItems[i]
//            
//            newBookMark.title = smallItems[i].title!
//            newBookMark.meta = smallItems[i].meta!
//            newBookMark.imgUrl = smallItems[i].img_url!
//            newBookMark.desc = smallItems[i].desc!
//            
//            newBookMark.heroImgUrl = fullItems[i].hero_img_url!
//            
//            var allKeys: [String] = []
//            var allValues: [String] = []
//            for descDict in fullItems[i].desc!.map({$0}) {
//                allKeys += descDict.keys.map{$0}
//                allValues += descDict.values.map{$0}
//            }
//            
//            newBookMark.descKeys = allKeys.joined(separator: "*FUCKREALM*")
//            newBookMark.descValues = allValues.joined(separator: "*FUCKREALM*")
//            
//            // Debug printing
////            print(allKeys)
////            print(allValues)
////            
////            print(citiesItems[i])
////            print(smallItems[i])
////            print(fullItems[i])
//            
//            realmBookmarks.append(newBookMark)
//            
//        }
//        
//        // Save to realm
//        for realmBookmark in realmBookmarks {
//            try! realm.write() {
//                realm.add(realmBookmark)
//            }
//        }
//        
//    }
    
    static func saveItemToCoreData(city: String, article: Article, fullArticle: FullArticle) {
        
        // Create a realm
        let realm = try! Realm()
        
        // Create bookmark
        let newBookMark = Bookmark()
        
        newBookMark.link = article.link!
        
        newBookMark.city = city
        
        newBookMark.title = article.title!
        newBookMark.meta = article.meta!
        newBookMark.imgUrl = article.img_url!
        newBookMark.desc = article.desc!
        
        newBookMark.heroImgUrl = fullArticle.hero_img_url!
        
        var allKeys: [String] = []
        var allValues: [String] = []
        for descDict in fullArticle.desc!.map({$0}) {
            allKeys += descDict.keys.map{$0}
            allValues += descDict.values.map{$0}
        }
        
        newBookMark.descKeys = allKeys.joined(separator: "*FUCKREALM*")
        newBookMark.descValues = allValues.joined(separator: "*FUCKREALM*")
        
        // Debug printing
        //            print(allKeys)
        //            print(allValues)
        //
        //            print(citiesItems[i])
        //            print(smallItems[i])
        //            print(fullItems[i])
        
        try! realm.write() {
            realm.add(newBookMark)
        }
    }
    
    static func deleteItemFromCoreData(link: String) {
        
        // Create a realm
        let realm = try! Realm()
        
        let itemToDelete = realm.objects(Bookmark.self).filter("link = '\(link)'")
        
        try! realm.write() {
            realm.delete(itemToDelete)
        }
        
    }
    
    // Load all bookmarks from core data
    static func loadFromCoreData() {
        
        // Create a realm
        let realm = try! Realm()
        
        // Load initial city
        let initialCities = realm.objects(InitialCity.self).map{$0}
        self.initialCity = initialCities.isEmpty ? "Bangkok" : initialCities[0].city
        
        // Add to bookmarks
        let realmBookmarks = realm.objects(Bookmark.self).map{$0}
        
        for i in realmBookmarks {

            // Setup cities
            citiesBookmark[i.link] = i.city
            
            // Setup bookmarks
            let a = Article(title: i.title, meta: i.meta, img_url: i.imgUrl, desc: i.desc, link: i.link)
            bookmarks[i.link] = a
            
            // Setup full bookmarks
            
            var desc: [[String: String]] = []
            let descKeys = i.descKeys.components(separatedBy: "*FUCKREALM*")
            let descValues = i.descValues.components(separatedBy: "*FUCKREALM*")
            
            for j in 0..<descKeys.count {
                let newDict: [String: String] = [descKeys[j]: descValues[j]]
                desc.append(newDict)
            }
            
            let fa = FullArticle(title: i.title, meta: i.meta, hero_img_url: i.heroImgUrl, desc: desc, link: i.link)
            fullBookmarks[i.link] = fa
            
        }
        
    }
    
    static func saveInitialCity(city: String) {
        
        // Create a realm
        let realm = try! Realm()
        
        // Delete old cities
        let realmCities = realm.objects(InitialCity.self)
        for i in realmCities {
            try! realm.write() {
                realm.delete(i)
            }
        }
        
        // Write new one
        let newCity = InitialCity()
        newCity.city = city
        try! realm.write() {
            realm.add(newCity)
        }
    }
    
    static func deleteAllFromRealm() {
        
        // Create a realm
        let realm = try! Realm()
        
        let realmBookmarks = realm.objects(Bookmark.self)
        
        for i in realmBookmarks {
            try! realm.write() {
                realm.delete(i)
            }
        }
        
    }
    
}
