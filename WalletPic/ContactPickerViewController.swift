//
//  ContactPickerViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 05.01.2016.
//  Copyright © 2016 128Pixels. All rights reserved.
//

import ContactsUI

class ContactPickerViewController: CNContactPickerViewController {
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      UIApplication.sharedApplication().statusBarStyle = .LightContent
      
   }
   
}
