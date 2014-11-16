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
   private var buttonViewHidden = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let image = UIImage(named: "bonobo") {
         
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
         //l.startPoint = CGPointMake(1.0, 0.8)
         //l.endPoint = CGPointMake(1.0, 1.0)
         self.imageView.layer.addSublayer(l)
         
         preferredContentSize = CGSize(width: newWidth, height: newHeight)
         
      }
      
      let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
      imageView.userInteractionEnabled = true
      imageView.addGestureRecognizer(tapGesture)
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
         options: .AllowUserInteraction | .BeginFromCurrentState,
         animations: { () -> Void in
            self.buttonViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
         }, completion: nil)
   }
   
   func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
   }

   func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
      println("sssa")
   // Perform any setup necessary in order to update the view.

   // If an error is encountered, use NCUpdateResult.Failed
   // If there's no update required, use NCUpdateResult.NoData
   // If there's an update, use NCUpdateResult.NewData

      completionHandler(NCUpdateResult.NewData)
   }
}