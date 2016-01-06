//
//  TodayViewController.swift
//  Widget
//
//  Created by Robert Lechowicz on 15.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
   
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var imageHeight: NSLayoutConstraint!
   @IBOutlet weak var imageWidth: NSLayoutConstraint!
   
   @IBOutlet weak var buttonView: UIView!
   @IBOutlet weak var buttonViewBottomConstraint: NSLayoutConstraint!
   @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
   
   @IBOutlet weak var buttonPhone: UIButton!
   @IBOutlet weak var buttonSMS: UIButton!
   @IBOutlet weak var buttonFB: UIButton!
   
   @IBOutlet weak var buttonPhoneWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var buttonSMSWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var buttonFBWidthConstraint: NSLayoutConstraint!
   
   private var buttonViewHidden = false
   
   let groupName = "group.com.128pixels.walletPic"
   
   var phone:String?
   var fbid:String?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      buttonPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
      buttonSMS.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
      buttonFB.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
      
      let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
      imageView.userInteractionEnabled = true
      imageView.addGestureRecognizer(tapGesture)
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      let buttonSize = round(self.view.frame.size.width / 6.4)
      buttonPhoneWidthConstraint.constant = buttonSize
      buttonSMSWidthConstraint.constant = buttonSize
      buttonFBWidthConstraint.constant = buttonSize
      buttonViewHeightConstraint.constant = buttonSize
      
      buttonPhone.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
      buttonSMS.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
      buttonFB.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
      
      view.layoutIfNeeded()
   }
   
   func imageTapped(recognizer:UITapGestureRecognizer) {
      buttonViewHidden = !buttonViewHidden
      
      let height = CGRectGetHeight(buttonView.bounds)
      var constant = buttonViewBottomConstraint.constant
      constant = buttonViewHidden ? -height : 20.0
      view.layoutIfNeeded()
      
      UIView.animateWithDuration(0.5,
         delay: 0,
         usingSpringWithDamping: 0.95,
         initialSpringVelocity: 1,
         options: [.AllowUserInteraction, .BeginFromCurrentState],
         animations: { () -> Void in
            self.buttonViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
         }, completion: nil)
   }
   
   @IBAction func buttonPhoneTapped(sender: UIButton) {
      if phone != nil {
         if let url = NSURL(string: "tel:\(phone!)") {
            print(url)
            extensionContext?.openURL(url, completionHandler: nil)
         }
      }
   }
   
   @IBAction func buttonSMSTapped(sender: UIButton) {
      if phone != nil {
         if let url = NSURL(string: "sms:\(phone!)") {
            print(url)
            extensionContext?.openURL(url, completionHandler: nil)
         }
      }
   }
   
   @IBAction func buttonFBTapped(sender: UIButton) {
      if fbid != nil {
         if let url = NSURL(string: "fb-messenger://user-thread/\(fbid!)") {
            print(url)
            extensionContext?.openURL(url, completionHandler: nil)
         }
      }
   }
   
   func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
   }

   func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
      let userDefaults = NSUserDefaults(suiteName: groupName)
      
      self.buttonPhone.enabled = false
      self.buttonSMS.enabled = false
      self.buttonFB.enabled = false
      
      if let phone = userDefaults?.objectForKey("phone") as! String? {
         self.phone = phone
         self.buttonPhone.enabled = true
         self.buttonSMS.enabled = true
      }
      
      if let fbid = userDefaults?.objectForKey("fbid") as! String? {
         self.fbid = fbid
         self.buttonFB.enabled = true
      }
      
   
      let possiblePath = userDefaults?.objectForKey("path") as! String?
      if let fileName = possiblePath {
         let fileManager = NSFileManager.defaultManager()
         let oUrl:NSURL? = fileManager.containerURLForSecurityApplicationGroupIdentifier(groupName)
         if var url = oUrl {
            
            url = NSURL(string: url.absoluteString + fileName)!
            if let image = UIImage(data: NSData(contentsOfURL: url)!) {
               let ratio = image.size.width / image.size.height
               let newWidth = self.view.frame.width
               let newHeight = round(newWidth / ratio)
               
               imageView.image = image
               imageWidth.constant = newWidth
               imageHeight.constant = newHeight
               self.view.layoutIfNeeded()
               
               
               
               let l = CAGradientLayer()
               l.frame = CGRectMake(0.0, newHeight - (round(newHeight / 2.4)), newWidth, round(newHeight / 2.4))
               
               l.colors = [UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.0).CGColor, UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).CGColor]
               self.imageView.layer.addSublayer(l)
               
               preferredContentSize = CGSize(width: newWidth, height: newHeight)
            }
         }
      }
      completionHandler(NCUpdateResult.NewData)
   }
}