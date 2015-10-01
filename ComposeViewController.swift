//
//  ComposeViewController.swift
//  Cwitter
//
//  Created by Kushal Bhatt on 9/30/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var composeTextView: UITextView!
    var tweetText:String?
    var charRemainingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTextView.delegate = self
        composeTextView.text = tweetText
        
        var charsRemaining = 140
        var buttonTitle = "Tweet"
        if let _ = tweetText {
            buttonTitle = "Reply"
            charsRemaining -= tweetText!.characters.count
        }
        
        
        let letfBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        navigationItem.setLeftBarButtonItem(letfBarButton, animated: true)
        
        let tweetButton = UIButton(type: UIButtonType.Custom)
        tweetButton.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        tweetButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        tweetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tweetButton.addTarget(self, action: "doSend", forControlEvents: .TouchUpInside)
        let tweetBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        charRemainingButton = UIButton(type: UIButtonType.Custom)
        charRemainingButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        charRemainingButton.setTitle(String(charsRemaining), forState: UIControlState.Normal)
        charRemainingButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        let charRemainingBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: charRemainingButton)
        
        
        navigationItem.setRightBarButtonItems([tweetBarButtonItem, charRemainingBarButtonItem], animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSend() {
        TwitterClient.sharedInstance.postTweet(["status":composeTextView.text]) { (error) -> () in
            if error == nil {
                //self.navigationController?.popViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textViewDidChange(textView: UITextView) {
        let len = textView.text.characters.count
        let charRemaining = 140 - len
        if charRemaining < 0 {
            charRemainingButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            charRemainingButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
         charRemainingButton.setTitle(String(charRemaining), forState: UIControlState.Normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
