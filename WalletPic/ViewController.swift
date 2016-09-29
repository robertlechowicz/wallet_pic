//
//  ViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 15.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import UIKit
import ContactsUI


class ViewController: UIViewController {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var canvasView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var buttonAddressPicker: UIButton!
  @IBOutlet weak var buttonCamera: UIButton!
  
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var fbField: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  
  let groupName = "group.com.128pixels.walletPic"
  
  fileprivate var lastScale:CGFloat = 1.0
  fileprivate var firstX:CGFloat = 0
  fileprivate var firstY:CGFloat = 0
  
  
  var tempImageFromAddress:UIImage?
  
  var tempPhoneNumbers = [(label:String, value:String)]()
  
  var shortIphone:Bool = false
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapAnywhere(_:)))
    self.view.addGestureRecognizer(tapRecognizer)
    
    buttonAddressPicker.layer.cornerRadius = 20.0
    
    
    self.containerView.isUserInteractionEnabled = true
    self.containerView.clipsToBounds = true
    
    let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.scaleImage(_:)))
    self.containerView.addGestureRecognizer(pinchRecognizer)
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panImage(_:)))
    self.canvasView.addGestureRecognizer(panRecognizer)
    
    let tapImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapImage(_:)))
    self.containerView.addGestureRecognizer(tapImageRecognizer)
    
    
    if UIScreen.main.nativeBounds.size.height < 1000 {
      shortIphone = true
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    showData()
  }
  
  func keyboardWillShow(_ notification: Notification) {
    
    if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 20.0, 0.0)
      scrollView.contentInset = contentInset
      scrollView.scrollIndicatorInsets = contentInset
    }
  }
  
  func keyboardWillHide(_ notification: Notification) {
    
    let contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    scrollView.contentInset = contentInset
    scrollView.scrollIndicatorInsets = contentInset
    
  }
  
  func showImageAlert(_ image:UIImage) {
    let alertImageView = UIAlertController(title: "", message: NSLocalizedString("Add photo from contact?", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
    let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertActionStyle.default, handler: { (action) -> Void in
      alertImageView.removeFromParentViewController()
      
      self.showImage(image)
      self.saveImage()
      
    })
    alertImageView.addAction(yesAction)
    let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: UIAlertActionStyle.default, handler: { (action) -> Void in
      alertImageView.removeFromParentViewController()
    })
    alertImageView.addAction(noAction)
    
    if let popoverController = alertImageView.popoverPresentationController {
      popoverController.sourceView = buttonAddressPicker
      popoverController.sourceRect = buttonAddressPicker.bounds
    }
    
    self.present(alertImageView, animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    
    if tempPhoneNumbers.count == 1 {
      self.phoneField.text = tempPhoneNumbers[0].value
      self.saveData()
      
      if let tempImage = self.tempImageFromAddress {
        self.showImageAlert(tempImage)
        self.tempImageFromAddress = nil
      }
      
    } else if tempPhoneNumbers.count > 1 {
      let alertPhoneView = UIAlertController(title: "", message: NSLocalizedString("Select phone number", comment: ""), preferredStyle: .actionSheet)
      
      
      for phone in tempPhoneNumbers {
        let action = UIAlertAction(title: phone.label + " " + phone.value, style: .default, handler: { (action) -> Void in
          self.phoneField.text = phone.value
          self.saveData()
          alertPhoneView.removeFromParentViewController()
          
          if let tempImage = self.tempImageFromAddress {
            self.showImageAlert(tempImage)
            self.tempImageFromAddress = nil
          }
          
        })
        alertPhoneView.addAction(action)
      }
      
      if let popoverController = alertPhoneView.popoverPresentationController {
        popoverController.sourceView = buttonAddressPicker
        popoverController.sourceRect = buttonAddressPicker.bounds
      }
      
      self.present(alertPhoneView, animated: true, completion: nil)
      
      tempPhoneNumbers.removeAll()
    }
    
    
  }
  
  func didTapAnywhere(_ recognizer:UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func buttonAddressPickerTapped(_ sender: UIButton) {
    
    self.view.endEditing(true)
    let picker = ContactPickerViewController()
    picker.delegate = self
    present(picker, animated: true, completion: nil)
  }
  
  
  
  
  @IBAction func buttonFacebookTapped(_ sender: UIButton) {
    self.view.endEditing(true)
  }
  
  @IBAction func buttonCameraTapped(_ sender: UIButton) {
    let picker = ImagePickerViewController()
    picker.delegate = self
    present(picker, animated: true, completion: nil)
  }
  
  
  func showImage(_ image:UIImage) {
    self.imageView.image = image
    self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
    self.imageView.clipsToBounds = true
    
    let imageRatio = image.size.width / image.size.height
    
    var scale: CGFloat
    if imageRatio > 4.0 / 3.0 {
      scale = self.containerView.frame.height / image.size.height
    } else {
      scale = self.containerView.frame.width / image.size.width
    }
    
    let newTransform = CGAffineTransform(scaleX: scale, y: scale)
    self.imageView.transform = newTransform
    self.imageView.center = CGPoint(x: self.containerView.center.x, y: self.containerView.center.y)
  }
  
  func scaleImage(_ recognizer:UIPinchGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.began {
      lastScale = 1.0
    }
    
    let scale:CGFloat = 1.0 - (lastScale - recognizer.scale)
    
    //let newWidth = imageView.frame.size.width * scale
    //let newHeight = imageView.frame.size.height * scale
    
    let currentTransform = imageView.transform
    let newTransform = currentTransform.scaledBy(x: scale, y: scale)
    
    self.imageView.transform = newTransform
    lastScale = recognizer.scale
    
    if recognizer.state == UIGestureRecognizerState.ended {
      fixImagePosition()
    }
  }
  
  func panImage(_ recognizer:UIPanGestureRecognizer) {
    var translatedPoint = recognizer.translation(in: self.canvasView)
    
    if recognizer.state == UIGestureRecognizerState.began {
      firstX = imageView.center.x
      firstY = imageView.center.y
    }
    
    translatedPoint = CGPoint(x: firstX + translatedPoint.x, y: firstY + translatedPoint.y)
    
    self.imageView.center = translatedPoint
    
    if recognizer.state == UIGestureRecognizerState.ended {
      fixImagePosition()
    }
  }
  
  func tapImage(_ recognizer:UITapGestureRecognizer) {
    self.view.endEditing(true)
    self.buttonCamera.isHidden = !self.buttonCamera.isHidden
  }
  
  func fixImagePosition() {
    //TODO: fix position & scale
    
    
    saveImage()
  }
  
  func saveImage() {
    UIGraphicsBeginImageContext(self.containerView.frame.size)
    self.containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let fileManager = FileManager.default
    
    //let imageData = UIImageJPEGRepresentation(image, 0.8)
    let imageData = UIImagePNGRepresentation(image!)
    let relativePath = "image_wallet_pic.png"
    let oUrl:URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupName)
    if var url = oUrl {
      
      url = URL(string: url.absoluteString + relativePath)!
      try? imageData?.write(to: url, options: [.atomic])
      
      
      let userDefaults = UserDefaults(suiteName: groupName)
      
      userDefaults?.set(relativePath, forKey: "path")
      
      userDefaults?.set(true, forKey: "updated")
      
      userDefaults?.synchronize()
      print("file saved") // at: \(url)")
    }
  }
  
  func saveData() {
    let userDefaults = UserDefaults(suiteName: groupName)
    
    let phoneNumberPretty = phoneField.text
    let fbName = fbField.text
    
    var phoneNumber = phoneNumberPretty
    phoneNumber = phoneNumber!.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")
    phoneNumber = phoneNumber!.replacingOccurrences(of: "-", with: "")
      .replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
    
    
    userDefaults?.set(phoneNumber, forKey: "phone")
    userDefaults?.set(phoneNumberPretty, forKey: "phonePretty")
    userDefaults?.set(fbName, forKey: "fbName")
    
    userDefaults?.set(true, forKey: "updated")
    
    userDefaults?.synchronize()
    
    print("data saved")
  }
  
  func showData() {
    let userDefaults = UserDefaults(suiteName: groupName)
    
    if let possiblePhone = userDefaults?.object(forKey: "phonePretty") as! String? {
      phoneField.text = possiblePhone
    }
    
    if let possibleFBName = userDefaults?.object(forKey: "fbName") as! String? {
      fbField.text = possibleFBName
    }
    
    let possiblePath = userDefaults?.object(forKey: "path") as! String?
    if let fileName = possiblePath {
      let fileManager = FileManager.default
      let oUrl:URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupName)
      if var url = oUrl {
        url = URL(string: url.absoluteString + fileName)!
        let imageData = try! Data(contentsOf: url)
        let image = UIImage(data: imageData)!
        self.imageView.image = image
        //println(self.imageView.image!.size)
        
      }
    } else {
      print("no file")
    }
  }
  
  
}

extension ViewController: CNContactPickerDelegate {
  func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    
    tempImageFromAddress = nil
    self.fbField.text = ""
    self.phoneField.text = ""
    
    if contact.imageDataAvailable {
      tempImageFromAddress = UIImage(data: contact.imageData!)!
      
    }
    
    tempPhoneNumbers.removeAll()
    for phone in contact.phoneNumbers {
      
      
      let t = (label: CNLabeledValue<NSString>.localizedString(forLabel: phone.label!),
               value: (phone.value as CNPhoneNumber).stringValue)
      tempPhoneNumbers.append(t)
    }
    
    if(contact.isKeyAvailable(CNContactInstantMessageAddressesKey)) {
      let messagers = contact.instantMessageAddresses
      for messager in messagers {
        let service = messager.value
        if service.service == "Facebook" {
           self.fbField.text = service.username
        }
      }
    }
    
    saveData()
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    saveData()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    saveData()
    return true
  }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
    dismiss(animated: true, completion: nil)
    
    showImage(image)
    saveImage()
  }
}

