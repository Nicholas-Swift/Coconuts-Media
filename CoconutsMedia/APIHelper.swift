//
//  APIHelper.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 10/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIHelper {
    
    static let baseUrl = "https://quiet-springs-53151.herokuapp.com"
    static let bangkokPath = "/bangkok"
    static let manilaPath = "/manila"
    static let singaporePath = "/singapore"
    static let hongkongPath = "/hongkong"
    static let kualalumpurPath = "/kl"
    static let jakartaPath = "/jakarta"
    static let baliPath = "/bali"
    static let yangonPath = "/yangon"
    static let indonesiaPath = "/indonesia"
    static let krungthepPath = "/krungthep"
    
    static func determinePath(city: String?) -> String {
        if city == "bangkok" {
            return bangkokPath
        }
        else if city == "manila" {
            return manilaPath
        }
        else if city == "singapore" {
            return singaporePath
        }
        else if city == "hong kong" {
            return hongkongPath
        }
        else if city == "kuala lumpur" {
            return kualalumpurPath
        }
        else if city == "jakarta" {
            return jakartaPath
        }
        else if city == "bali" {
            return baliPath
        }
        else if city == "yangon" {
            return yangonPath
        }
        else if city == "indonesia" {
            return indonesiaPath
        }
        else if city == "krungthep" {
            return krungthepPath
        }
        else {
            return bangkokPath
        }
    }
    
    static func getArticles(city: String?, complete: @escaping ( _ articles: [Article], _ error: NSError?) -> Void) {
        
        let cityPath = determinePath(city: city)
        let url = APIHelper.baseUrl + "/articles" + cityPath + "?page=\(0)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            // Success
            case .success:
                if let value = response.result.value {
                
                    var articles: [Article] = []
                    
                    let json = JSON(value)
                    let dictList = json.arrayValue
                    
                    for i in dictList {
                        let title = i["title"].stringValue
                        let meta = i["meta"].stringValue
                        let imgUrl = i["img_url"].stringValue
                        let desc = i["desc"].stringValue
                        let link = i["link"].stringValue
                        let article = Article(title: title, meta: meta, img_url: imgUrl, desc: desc, link: link)
                        articles.append(article)
                    }
                    
                    complete(articles, nil)
                }
                
                // Failure
            case .failure(let error):
                print("error: \(error)")
                complete([], error as NSError?)
            }
            
        }
        
    }
    
    static func getArticles(city: String?, pageNumber: Int, complete: @escaping ( _ articles: [Article], _ error: NSError?) -> Void) {
        
        let cityPath = determinePath(city: city)
        let url = APIHelper.baseUrl + "/articles" + cityPath + "?page=\(pageNumber)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            // Success
            case .success:
                if let value = response.result.value {
                    
                    var articles: [Article] = []
                    
                    let json = JSON(value)
                    let dictList = json.arrayValue
                    
                    for i in dictList {
                        let title = i["title"].stringValue
                        let meta = i["meta"].stringValue
                        let imgUrl = i["img_url"].stringValue
                        let desc = i["desc"].stringValue
                        let link = i["link"].stringValue
                        let article = Article(title: title, meta: meta, img_url: imgUrl, desc: desc, link: link)
                        articles.append(article)
                    }
                    
                    complete(articles, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete([], error as NSError?)
            }
            
        }
        
    }
    
    static func showArticle(city: String?, link: String, complete: @escaping ( _ article: FullArticle?, _ error: NSError?) -> Void) {
     
        let city = determinePath(city: city)
        let path = "/articles" + city + link
        let url = APIHelper.baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            // Success
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let dictList = json.arrayValue
                    
                    let title = json["title"].stringValue
                    let meta = json["meta"].stringValue
                    let heroImgUrl = json["hero_img_url"].stringValue
                    
                    var desc: [[String: String]] = []
                    let paragraphs = json["paragraphs"].arrayValue
                    for i in paragraphs {
                        desc.append([i["type"].stringValue: i["result"].stringValue])
                    }
                    
                    let link = json["link"].stringValue
                    let article = FullArticle(title: title, meta: meta, hero_img_url: heroImgUrl, desc: desc, link: link)

                    
                    complete(article, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
            
        }
        
    }
    
}
