//
//  ViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 15.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CNContactPickerDelegate {

   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var canvasView: UIView!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var buttonAddressPicker: UIButton!
   @IBOutlet weak var buttonFacebook: UIButton!
   @IBOutlet weak var buttonCamera: UIButton!
   
   @IBOutlet weak var phoneField: UITextField!
   @IBOutlet weak var fbField: UITextField!
   
   @IBOutlet weak var circle: CircleView!
   @IBOutlet weak var circleOr: UILabel!
   
   @IBOutlet weak var buttonAddressPickerTopConstraint: NSLayoutConstraint!
   @IBOutlet weak var buttonFacebookTopConstraint: NSLayoutConstraint!
   
   let groupName = "group.com.128pixels.walletPic"
   
   private var lastScale:CGFloat = 1.0
   private var firstX:CGFloat = 0
   private var firstY:CGFloat = 0
   
   var fbid:String?
   var fbName:String?
   
   var tempImageFromAddress:UIImage?
   
   var tempPhoneNumbers = [(label:String, value:String)]()
   
   var shortIphone:Bool = false
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTapAnywhere:"))
      self.view.addGestureRecognizer(tapRecognizer)
      
      buttonAddressPicker.layer.cornerRadius = 20.0
      buttonFacebook.layer.cornerRadius = 20.0
      
      self.containerView.userInteractionEnabled = true
      self.containerView.clipsToBounds = true
      
      let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "scaleImage:")
      self.containerView.addGestureRecognizer(pinchRecognizer)
      
      let panRecognizer = UIPanGestureRecognizer(target: self, action: "panImage:")
      self.canvasView.addGestureRecognizer(panRecognizer)
      
      let tapImageRecognizer = UITapGestureRecognizer(target: self, action: "tapImage:")
      self.containerView.addGestureRecognizer(tapImageRecognizer)
      
      
      if UIScreen.mainScreen().nativeBounds.size.height < 1000 {
         shortIphone = true
      }
      
      showData()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      if shortIphone {
         circle.hidden = true
         circleOr.hidden = true
         
         buttonAddressPickerTopConstraint.constant = 8.0
         buttonFacebookTopConstraint.constant = 8.0
      }
      
      
      if tempPhoneNumbers.count == 1 {
         self.phoneField.text = tempPhoneNumbers[0].value
         self.saveData()
      } else if tempPhoneNumbers.count > 1 {
         let alertPhoneView = UIAlertController(title: "", message: NSLocalizedString("Select phone number", comment: ""), preferredStyle: .ActionSheet)
         
         
         for phone in tempPhoneNumbers {
            let action = UIAlertAction(title: phone.label + " " + phone.value, style: .Default, handler: { (action) -> Void in
               self.phoneField.text = phone.value
               self.saveData()
               alertPhoneView.removeFromParentViewController()
            })
            alertPhoneView.addAction(action)
         }
         
         if let popoverController = alertPhoneView.popoverPresentationController {
            popoverController.sourceView = buttonAddressPicker
            popoverController.sourceRect = buttonAddressPicker.bounds
         }
         
         self.presentViewController(alertPhoneView, animated: true, completion: nil)
         
         tempPhoneNumbers.removeAll()
      }
      
      if tempImageFromAddress != nil {
         let alertImageView = UIAlertController(title: "", message: NSLocalizedString("Add photo from contact?", comment: ""), preferredStyle: UIAlertControllerStyle.ActionSheet)
         let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            alertImageView.removeFromParentViewController()
            
            self.showImage(self.tempImageFromAddress!)
            self.tempImageFromAddress = nil
            self.saveImage()
            
         })
         alertImageView.addAction(yesAction)
         let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            alertImageView.removeFromParentViewController()
            
            self.tempImageFromAddress = nil
         })
         alertImageView.addAction(noAction)
         
         if let popoverController = alertImageView.popoverPresentationController {
            popoverController.sourceView = buttonAddressPicker
            popoverController.sourceRect = buttonAddressPicker.bounds
         }
         self.presentViewController(alertImageView, animated: true, completion: nil)
      }
   }
   
   func didTapAnywhere(recognizer:UITapGestureRecognizer) {
      self.view.endEditing(true)
   }
   
   @IBAction func buttonAddressPickerTapped(sender: UIButton) {
      self.view.endEditing(true)
      let picker = ContactPickerViewController()
      picker.delegate = self
      presentViewController(picker, animated: true, completion: nil)
   }
   
   func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
      if contact.imageDataAvailable {
         tempImageFromAddress = UIImage(data: contact.imageData!)!
         
      }
      
      tempPhoneNumbers.removeAll()
      for phone in contact.phoneNumbers {
         let t = (label: CNLabeledValue.localizedStringForLabel(phone.label), value: (phone.value as! CNPhoneNumber).stringValue)
         tempPhoneNumbers.append(t)
      }
      
      saveData()
   }
   
   
   @IBAction func buttonFacebookTapped(sender: UIButton) {
      self.view.endEditing(true)
   }
   
   @IBAction func buttonCameraTapped(sender: UIButton) {
      let picker = UIImagePickerController()
      picker.delegate = self
      presentViewController(picker, animated: true, completion: nil)
   }
   
   func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
      dismissViewControllerAnimated(true, completion: nil)
      
      
      showImage(image)
      saveImage()
   }
   
   func showImage(image:UIImage) {
      self.imageView.image = image
      self.imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
      self.imageView.clipsToBounds = true
      
      let imageRatio = image.size.width / image.size.height
      
      var scale: CGFloat
      if imageRatio > 4.0 / 3.0 {
         scale = self.containerView.frame.height / image.size.height
      } else {
         scale = self.containerView.frame.width / image.size.width
      }

      let newTransform = CGAffineTransformMakeScale(scale, scale)
      self.imageView.transform = newTransform
      self.imageView.center = CGPointMake(self.containerView.center.x, self.containerView.center.y)
   }
   
   func scaleImage(recognizer:UIPinchGestureRecognizer) {
      if recognizer.state == UIGestureRecognizerState.Began {
         lastScale = 1.0
      }
      
      let scale:CGFloat = 1.0 - (lastScale - recognizer.scale)
      
      //let newWidth = imageView.frame.size.width * scale
      //let newHeight = imageView.frame.size.height * scale
      
      let currentTransform = imageView.transform
      let newTransform = CGAffineTransformScale(currentTransform, scale, scale)
      
      self.imageView.transform = newTransform
      lastScale = recognizer.scale
      
      if recognizer.state == UIGestureRecognizerState.Ended {
         fixImagePosition()
      }
   }
   
   func panImage(recognizer:UIPanGestureRecognizer) {
      var translatedPoint = recognizer.translationInView(self.canvasView)
      
      if recognizer.state == UIGestureRecognizerState.Began {
         firstX = imageView.center.x
         firstY = imageView.center.y
      }
      
      translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y)
      
      self.imageView.center = translatedPoint
      
      if recognizer.state == UIGestureRecognizerState.Ended {
         fixImagePosition()
      }
   }
   
   func tapImage(recognizer:UITapGestureRecognizer) {
      self.view.endEditing(true)
      self.buttonCamera.hidden = !self.buttonCamera.hidden
   }
   
   func fixImagePosition() {
//TODO: fix position & scale
      
      
      saveImage()
   }
   
   func saveImage() {
      UIGraphicsBeginImageContext(self.containerView.frame.size)
      self.containerView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      let fileManager = NSFileManager.defaultManager()
      
      //let imageData = UIImageJPEGRepresentation(image, 0.8)
      let imageData = UIImagePNGRepresentation(image)
      let relativePath = "image_wallet_pic.png"
      let oUrl:NSURL? = fileManager.containerURLForSecurityApplicationGroupIdentifier(groupName)
      if var url = oUrl {
         
         url = NSURL(string: url.absoluteString + relativePath)!
         imageData?.writeToURL(url, atomically: true)
         
         
         let userDefaults = NSUserDefaults(suiteName: groupName)
         
         userDefaults?.setObject(relativePath, forKey: "path")
         
         userDefaults?.synchronize()
         print("file saved") // at: \(url)")
      }
   }
   
   func saveData() {
      let userDefaults = NSUserDefaults(suiteName: groupName)
      
      let phoneNumberPretty = phoneField.text
      var phoneNumber = phoneNumberPretty
      phoneNumber = phoneNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).joinWithSeparator("")
      phoneNumber = phoneNumber!.stringByReplacingOccurrencesOfString("-", withString: "")
         .stringByReplacingOccurrencesOfString("(", withString: "")
         .stringByReplacingOccurrencesOfString(")", withString: "")
      
      
      userDefaults?.setObject(phoneNumber, forKey: "phone")
      userDefaults?.setObject(phoneNumberPretty, forKey: "phonePretty")
      userDefaults?.setObject(self.fbid, forKey: "fbid")
      userDefaults?.setObject(self.fbName, forKey: "fbName")
      userDefaults?.synchronize()
   }
   
   func showData() {
      let userDefaults = NSUserDefaults(suiteName: groupName)
      
      if let possiblePhone = userDefaults?.objectForKey("phonePretty") as! String? {
         phoneField.text = possiblePhone
      }
      
      if let possibleFB = userDefaults?.objectForKey("fbid") as! String? {
         fbField.text = possibleFB
      }
      if let possibleFBName = userDefaults?.objectForKey("fbName") as! String? {
         fbField.text = "\(possibleFBName)  (\(fbField.text!))"
      }
      
      let possiblePath = userDefaults?.objectForKey("path") as! String?
      if let fileName = possiblePath {
         let fileManager = NSFileManager.defaultManager()
         let oUrl:NSURL? = fileManager.containerURLForSecurityApplicationGroupIdentifier(groupName)
         if var url = oUrl {
            url = NSURL(string: url.absoluteString + fileName)!
            let imageData = NSData(contentsOfURL: url)!
            let image = UIImage(data: imageData)!
            self.imageView.image = image
            //println(self.imageView.image!.size)
            
         }
      } else {
         print("no file")
      }
   }
   
//MARK: facebook
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "FacebookSegue" {
         ((segue.destinationViewController as! UINavigationController).viewControllers[0] as! FacebookPicker).delegate = self
      }
   }
   
   func setFacebookData(data:Dictionary<String, AnyObject>) {

      if let fbid = data["id"] as? String {
         self.fbid = fbid
         
         self.fbField.text = self.fbid
         
         if let fbFirstName = data["first_name"] as? String {
            if let fbLastName = data["last_name"] as? String {
               self.fbName = "\(fbFirstName) \(fbLastName)"
               
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                  self.fbField.text = "\(self.fbName!) (\(self.fbid!))"
               })
               
               saveData()
            }
         }
      } else {
         self.fbid = nil
      }
   }
   
//MARK: UITextField
   func textFieldDidEndEditing(textField: UITextField) {
      saveData()
   }
}

