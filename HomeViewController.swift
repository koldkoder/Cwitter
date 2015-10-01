//
//  HomeViewController.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 9/26/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, TweetCellTableViewCellDelegate {

    @IBOutlet weak var tweetListTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?
    var replyTo: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetListTableView.delegate = self
        tweetListTableView.dataSource = self
        tweetListTableView.rowHeight = UITableViewAutomaticDimension
        tweetListTableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
        setNavigationButtons()
        addRefreshControl()
        fetchTweets()
        

    }
    
    
    func setNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.blueColor()
        let signOutButton = UIBarButtonItem(title: "Sign out", style: UIBarButtonItemStyle.Plain, target: self, action: "doSignOut")
        navigationItem.leftBarButtonItem = signOutButton
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "doCompose")
        navigationItem.rightBarButtonItem = tweetButton
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimeLineWithParams([:], completion: { (tweets, error) -> () in
            self.refreshControl.endRefreshing()
            if(tweets != nil) {
                self.tweets = tweets
                self.tweetListTableView.reloadData()
            }
        })
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetListTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onRefresh() {
        fetchTweets()
    }
    
    func doSignOut() {
        User.currentUser?.logout()
    }
    
    func doCompose() {
        replyTo = nil
        doTweet()
    }
    
    func doReply(replyTo: String) {
        self.replyTo = replyTo
        doTweet()
    }
    
    func doTweet() {
        performSegueWithIdentifier("composeSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCellTableViewCell
        let tweet = tweets![indexPath.row]
        tweetCell.tweet = tweet
        tweetCell.delegate = self
        return tweetCell
    }

    
    func tweetCellTableViewCell(tweetCell: TweetCellTableViewCell, buttonTapped value: String) {
        let indexPath = tweetListTableView.indexPathForCell(tweetCell)!
        let tweetId = tweets![indexPath.row].id
        switch value {
            case "favorite":
                tweets![indexPath.row].favorited = tweetCell.favoriteButton.selected
                
                if tweetCell.favoriteButton.selected {
                    TwitterClient.sharedInstance.favoriteTweet(tweetId)
                } else {
                    TwitterClient.sharedInstance.unFavoriteTweet(tweetId)
                }
            
            case "retweet":
                tweets![indexPath.row].retweeted = tweetCell.retweetButton.selected
                
                if tweetCell.retweetButton.selected {
                    TwitterClient.sharedInstance.reTweet(tweetId)
                } else {
                    //TwitterClient.sharedInstance.unReTweet(tweetId)
                }
            
            case "reply":
                let tweet = tweets![indexPath.row]
                doReply("@" + (tweet.user?.screenname)!)
                break;
        default:
            break;
            
        }
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
            case "detailSegue":
                let cell = sender as! UITableViewCell
                let indexPath = tweetListTableView.indexPathForCell(cell)!
                let tweet = tweets![indexPath.row]
                let detailViewController = segue.destinationViewController as! TweetDetailViewController
                detailViewController.tweet = tweet
                break;
        default:
            break;
        }
    }


}
