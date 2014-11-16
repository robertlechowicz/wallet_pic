//
//  ViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 15.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var canvasView: UIView!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var buttonAddressPicker: UIButton!
   @IBOutlet weak var buttonFacebook: UIButton!
   @IBOutlet weak var buttonCamera: UIButton!
   
   
   let groupName = "group.com.128pixels.walletPic"
   
   private var lastScale:CGFloat = 1.0
   private var firstX:CGFloat = 0
   private var firstY:CGFloat = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      //Lato-Regular
      
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
   }
   
   func didTapAnywhere(recognizer:UITapGestureRecognizer) {
      self.view.endEditing(true)
   }
   @IBAction func buttonAddressPickerTapped(sender: UIButton) {
      self.view.endEditing(true)
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
   }
   
   func showImage(image:UIImage) {
      self.imageView.image = image
   }
   
   func scaleImage(recognizer:UIPinchGestureRecognizer) {
      if recognizer.state == UIGestureRecognizerState.Began {
         lastScale = 1.0
      }
      
      let scale:CGFloat = 1.0 - (lastScale - recognizer.scale)
      
      let newWidth = imageView.frame.size.width * scale
      let newHeight = imageView.frame.size.height * scale
      
      let currentTransform = imageView.transform
      let newTransform = CGAffineTransformScale(currentTransform, scale, scale)
      self.imageView.transform = newTransform
      lastScale = recognizer.scale
   }
   
   func panImage(recognizer:UIPanGestureRecognizer) {
      var translatedPoint = recognizer.translationInView(self.canvasView)
      
      if recognizer.state == UIGestureRecognizerState.Began {
         firstX = imageView.center.x
         firstY = imageView.center.y
      }
      
      translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y)
      
      self.imageView.center = translatedPoint
      
   }
   
   func tapImage(recognizer:UITapGestureRecognizer) {
      self.buttonCamera.hidden = !self.buttonCamera.hidden
   }
   
}

