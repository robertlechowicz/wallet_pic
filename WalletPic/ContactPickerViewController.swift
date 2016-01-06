//
//  ContactPickerViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 05.01.2016.
//  Copyright © 2016 128Pixels. All rights reserved.
//

import ContactsUI

class ContactPickerViewController: CNContactPickerViewController {

   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.Default
   }
   
}
