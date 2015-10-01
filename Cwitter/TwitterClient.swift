//
//  TwitterClient.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 9/26/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

let twitterConsumerKey = "u8fJM2IKMNNIK0osfiHdRatSf"
let twitterConsumerSecret = "X0dMZe1vh1JSVjouVlhehMD9eiK2EGGHtpMDVI4x3lgUNxBSsk"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary, completion:(tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (opearation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting home timeline")
                completion(tweets: nil, error: error)
            })

    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redeirec to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                print("Failed to get request token:\(error) ")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func favoriteTweet(id:String) {
        let params:NSDictionary = ["id":id]
        POST("https://api.twitter.com/1.1/favorites/create.json", parameters: params, constructingBodyWithBlock: nil, success: nil) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error favorating tweet ", id, error)
        }
    }
    
    func unFavoriteTweet(id:String) {
        let params:NSDictionary = ["id":id]
        POST("https://api.twitter.com/1.1/favorites/destroy.json", parameters: params, constructingBodyWithBlock: nil, success: nil) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error unfavorating tweet ", id, error)
        }
    }
    
    func reTweet(id:String) {
        POST("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, constructingBodyWithBlock: nil, success: nil) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error retweeting  ", id, error)
        }
    }
    
    func unReTweet(id:String) {
        POST("https://api.twitter.com/1.1/statuses/destroy/\(id).json", parameters: nil, constructingBodyWithBlock: nil, success: nil) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error un retweeting ", id, error)
        }
    }
    
    func postTweet(params:NSDictionary, completion:(error: NSError?) -> ()) {
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: params, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error posting Tweet", error)
                completion(error: error)
        }
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("Got the Access Token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user:\(user.name)")
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("Error getting user")
                    self.loginCompletion?(user: nil, error: error)
                    
            })
            
            
        })
        {
            (error:NSError!) -> Void in
            print("Failed to recieve acesss token \(error)")
            self.loginCompletion?(user: nil, error: error)
        }

    }
}
