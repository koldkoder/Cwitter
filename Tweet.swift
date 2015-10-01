//
//  Tweet.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 9/27/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import Foundation
import UIKit

class Tweet: NSObject {
    var id: String
    var user: User?
    var retweetOfUser: User?
    var text: String?
    var createAtString: String?
    var createdAt: NSDate?
    var favorited: Bool
    var retweeted: Bool
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as! String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        if let retweetedStatus = retweetedStatus {
           retweetOfUser = User(dictionary: (retweetedStatus["user"] as! NSDictionary))
           text = retweetedStatus["text"] as? String
        }
        
        createAtString = dictionary["created_at"] as? String
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let createAtString = createAtString {
            createdAt = formatter.dateFromString(createAtString)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}

