//
//  TweetCellTableViewCell.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 9/26/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

@objc protocol TweetCellTableViewCellDelegate {
    optional func tweetCellTableViewCell(tweetCell: TweetCellTableViewCell, buttonTapped value: String)
}

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var contentCeilingConstraint: NSLayoutConstraint!
    
    weak var delegate: TweetCellTableViewCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text
            
            retweetButton.selected = tweet.retweeted
            favoriteButton.selected = tweet.favorited

            if let profileImageUrl = tweet.user?.profileImageUrl {
                let httpsUrl = profileImageUrl.stringByReplacingOccurrencesOfString("http://", withString: "https://")
                profileImageView.setImageWithURL(NSURL(string: httpsUrl))
            }
            retweetLabel.hidden = true
            retweetImage.hidden = true
            retweetLabel.text = nil
            if let retweetUser = tweet.retweetOfUser {
                contentCeilingConstraint.constant = 20
                userNameLabel.text = retweetUser.name
                userHandleLabel.text = "@" + retweetUser.screenname!
                if let name = tweet.user?.name {
                    retweetLabel.text = name + " Retweeted"
                    retweetImage.hidden = false
                    retweetLabel.hidden = false
                }
                if let profileImageUrl = retweetUser.profileImageUrl {
                    let httpsUrl = profileImageUrl.stringByReplacingOccurrencesOfString("http://", withString: "https://")
                    profileImageView.setImageWithURL(NSURL(string: httpsUrl))
                }
                
            } else {
                userNameLabel.text = tweet.user?.name
                userHandleLabel.text = "@"+tweet.user!.screenname!
                contentCeilingConstraint.constant = 4
            }
           
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setImage(UIImage(named: "favorite_on"), forState: UIControlState.Selected)
        favoriteButton.setImage(UIImage(named: "favorite"), forState: UIControlState.Normal)
        
        retweetButton.setImage(UIImage(named: "retweet_on"), forState: UIControlState.Selected)
        retweetButton.setImage(UIImage(named: "retweet"), forState: UIControlState.Normal)
    }
    
    
    @IBAction func favoriteTouchUp(sender: AnyObject) {
        favoriteButton.selected = !favoriteButton.selected
        delegate?.tweetCellTableViewCell?(self, buttonTapped: "favorite")
    }
    
    @IBAction func retweetTouchUp(sender: AnyObject) {
        retweetButton.selected = !retweetButton.selected
        delegate?.tweetCellTableViewCell?(self, buttonTapped: "retweet")
    }
    
    @IBAction func replyTouchUp(sender: AnyObject) {
         delegate?.tweetCellTableViewCell?(self, buttonTapped: "reply")
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
