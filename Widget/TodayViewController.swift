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
   
   fileprivate var buttonViewHidden = false
   
   let groupName = "group.com.128pixels.walletPic"
   
   var phone:String?
   var fbid:String?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      buttonPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
      buttonSMS.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
      buttonFB.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TodayViewController.imageTapped(_:)))
      imageView.isUserInteractionEnabled = true
      imageView.addGestureRecognizer(tapGesture)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      updateData()
      
      let buttonSize = round(self.view.frame.size.width / 6.4)
      buttonPhoneWidthConstraint.constant = buttonSize
      buttonSMSWidthConstraint.constant = buttonSize
      buttonFBWidthConstraint.constant = buttonSize
      buttonViewHeightConstraint.constant = buttonSize
      
      buttonPhone.imageView?.contentMode = UIViewContentMode.scaleAspectFill
      buttonSMS.imageView?.contentMode = UIViewContentMode.scaleAspectFill
      buttonFB.imageView?.contentMode = UIViewContentMode.scaleAspectFill
      
      view.layoutIfNeeded()
   }
   
   func imageTapped(_ recognizer:UITapGestureRecognizer) {
      

      
      buttonViewHidden = !buttonViewHidden
      
      let height = buttonView.bounds.height
      var constant = buttonViewBottomConstraint.constant
      constant = buttonViewHidden ? -height : 20.0
      view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.5,
         delay: 0,
         usingSpringWithDamping: 0.95,
         initialSpringVelocity: 1,
         options: [.allowUserInteraction, .beginFromCurrentState],
         animations: { () -> Void in
            self.buttonViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
         }, completion: nil)
   }
   
   @IBAction func buttonPhoneTapped(_ sender: UIButton) {
      if phone != nil {
         if let url = URL(string: "tel:\(phone!)") {
            print(url)
            extensionContext?.open(url, completionHandler: nil)
         }
      }
   }
   
   @IBAction func buttonSMSTapped(_ sender: UIButton) {
      if phone != nil {
         if let url = URL(string: "sms:\(phone!)") {
            print(url)
            extensionContext?.open(url, completionHandler: nil)
         }
      }
   }
   
   @IBAction func buttonFBTapped(_ sender: UIButton) {
      if fbid != nil {
         if let url = URL(string: "fb-messenger://user-thread/\(fbid!)") {
            print(url)
            extensionContext?.open(url, completionHandler: nil)
         }
      }
   }
   
   func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
   }

   func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
      updateData()
      
      completionHandler(NCUpdateResult.newData)
   }
   
   func updateData() {
      let userDefaults = UserDefaults(suiteName: groupName)
      
      self.buttonPhone.isEnabled = false
      self.buttonSMS.isEnabled = false
      self.buttonFB.isEnabled = false
      
      if let phone = userDefaults?.object(forKey: "phone") as! String? {
         if phone != "" {
            self.phone = phone
            self.buttonPhone.isEnabled = true
            self.buttonSMS.isEnabled = true
         }
      }
      
      if let fbname = userDefaults?.object(forKey: "fbName") as! String? {
         if fbname != "" {
            self.fbid = fbname
            self.buttonFB.isEnabled = true
         }
      }
      
      
      let possiblePath = userDefaults?.object(forKey: "path") as! String?
      if let fileName = possiblePath {
         let fileManager = FileManager.default
         let oUrl:URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupName)
         if var url = oUrl {
            
            url = URL(string: url.absoluteString + fileName)!
            if let image = UIImage(data: try! Data(contentsOf: url)) {
               let ratio = image.size.width / image.size.height
               let newWidth = self.view.frame.width
               let newHeight = round(newWidth / ratio)
               
               _ = imageView.layer.sublayers?.map({ (layer) in
                  layer.removeFromSuperlayer()
               })
               imageView.image = image
               imageWidth.constant = newWidth
               imageHeight.constant = newHeight
               self.view.layoutIfNeeded()
               
               
               
               let l = CAGradientLayer()
               l.frame = CGRect(x: 0.0, y: newHeight - (round(newHeight / 2.4)), width: newWidth, height: round(newHeight / 2.4))
               
               l.colors = [UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.0).cgColor, UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).cgColor]
               self.imageView.layer.addSublayer(l)
               
               preferredContentSize = CGSize(width: newWidth, height: newHeight)
            }
         }
      }
      
   }
}
