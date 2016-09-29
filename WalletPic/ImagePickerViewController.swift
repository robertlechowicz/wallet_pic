//
//  ImagePickerViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 13.01.2016.
//  Copyright © 2016 128Pixels. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIImagePickerController {

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      UIApplication.shared.statusBarStyle = .lightContent
      
   }

}
