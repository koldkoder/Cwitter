//
//  TweetDetailViewController.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 10/1/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellTableViewCellDelegate {

    @IBOutlet weak var tweetDetailTableView: UITableView!
    var tweet: Tweet!
    var replyTo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetDetailTableView.delegate = self
        tweetDetailTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCellTableViewCell
        tweetCell.tweet = tweet
        tweetCell.delegate = self
        return tweetCell
    }
    
    func tweetCellTableViewCell(tweetCell: TweetCellTableViewCell, buttonTapped value: String) {
        let tweetId = tweet.id
        switch value {
        case "favorite":
            tweet.favorited = tweetCell.favoriteButton.selected
            
            if tweetCell.favoriteButton.selected {
                TwitterClient.sharedInstance.favoriteTweet(tweetId)
            } else {
                TwitterClient.sharedInstance.unFavoriteTweet(tweetId)
            }
            
        case "retweet":
            tweet.retweeted = tweetCell.retweetButton.selected
            
            if tweetCell.retweetButton.selected {
                TwitterClient.sharedInstance.reTweet(tweetId)
            } else {
                //TwitterClient.sharedInstance.unReTweet(tweetId)
            }
            
        case "reply":
            doReply("@" + (tweet.user?.screenname)!)
            break;
        default:
            break;
            
        }
    }
    
    func doReply(replyTo: String) {
        self.replyTo = replyTo
        doTweet()
    }
    
    func doTweet() {
        performSegueWithIdentifier("composeSegue", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueId = segue.identifier!
        switch segueId {
        case "composeSegue":
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            composeViewController.tweetText = replyTo
        default:
            break;
        }
    }
    

}
