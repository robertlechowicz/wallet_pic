//
//  FacebookPicker.swift
//  launcher
//
//  Created by Robert Lechowicz on 22.10.2014.
//  Copyright (c) 2014 Robert Lechowicz. All rights reserved.
//

import Foundation
import UIKit

class FacebookPickerOld: UIViewController, UIWebViewDelegate {
   
   var delegate:ViewController?
   
   @IBOutlet weak var webView: UIWebView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
   
   
   @IBAction func cancelTapped(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: { () -> Void in
         
      })
      
      
   }
   @IBAction func doneTapped(sender: AnyObject) {
      if let url = webView.stringByEvaluatingJavaScriptFromString("window.location.href") {
         let name = (url as NSString).lastPathComponent
         if name == "friends" {
            self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You have to open your friend profile page", comment: ""))
            return
         }
         let graphURL = NSURL(string: "https://graph.facebook.com/\(name)")!
         loadFriendDataFrom(graphURL)
      }
   }
   
   func loadFriendDataFrom(url:NSURL) {
      let session = NSURLSession.sharedSession()
      
      session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
         print("-----")
         print(response)
         print("-----")
      }).resume()
      
//      session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
//         let httpResp = response as! NSHTTPURLResponse
//         if httpResp.statusCode == 200 {
//            let jsonError:NSError?
//            if let friendJSON = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
//            if jsonError == nil {
//               if friendJSON["error"] == nil {                  
//                  if self.delegate != nil {
//                     self.delegate!.setFacebookData(friendJSON as! Dictionary)
//                  }
//                  self.dismissViewControllerAnimated(true, completion: nil)
//                  
//               } else {
//                  self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You have to open your friend profile page", comment: ""))
//               }
//            }
//            } else {
//               self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You have to open your friend profile page", comment: ""))
//            }
//         } else {
//            self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: "Some strange error: \(httpResp)")
//         }
//      }).resume()
   }
   
   override func viewDidLoad() {
      webView.delegate = self
      webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://m.facebook.com/friends/center/friends/")!))
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      activityIndicator.hidesWhenStopped = true
      activityIndicator.stopAnimating()
      
   }
   
   override func viewDidDisappear(animated: Bool) {
      super.viewDidDisappear(animated)
      activityIndicator.stopAnimating()
   }
   
   func showAlertWith(title title:String, message:String) {
      let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
      let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
         alertView.removeFromParentViewController()
      })
      alertView.addAction(okAction)
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         self.presentViewController(alertView, animated: true, completion: nil)
      })
      
   }
   
   func webViewDidFinishLoad(webView: UIWebView) {
      activityIndicator.stopAnimating()
   }
   
   func webViewDidStartLoad(webView: UIWebView) {
      activityIndicator.startAnimating()
   }
}
