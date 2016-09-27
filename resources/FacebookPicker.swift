//
//  FacebookPickeTableViewController.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 07.01.2016.
//  Copyright © 2016 128Pixels. All rights reserved.
//

import UIKit

class FacebookPicker: UITableViewController {

   var delegate:FacebookPickerDelegate?
   
   
   @IBAction func cancelTapped(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
//      self.tableView.tableFooterView = UIView()
      
      if FBSDKAccessToken.currentAccessToken() == nil {
         
         let login = FBSDKLoginManager()
         login.logInWithReadPermissions(["user_friends"], fromViewController: self, handler: { (result, error) -> Void in
            if error != nil {
               print(error)
            } else if result.isCancelled {
               self.dismissViewControllerAnimated(false, completion: nil)
               let alert = UIAlertController(title: "", message: "You must login to Facebook and grant access to your firends list to use this feature.", preferredStyle: .Alert)
               let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
               alert.addAction(alertAction)
               self.presentViewController(alert, animated: true, completion: nil)
            } else {
               print("LoggedIn")
               
               self.fetchFacebookFriends()
            }
         })
      } else {
         print("facebook logged")
         self.fetchFacebookFriends()
      }
      
      
    }
   
   func fetchFacebookFriends() {
      if FBSDKAccessToken.currentAccessToken() != nil {
         FBSDKGraphRequest.init(graphPath: "/me/friends/?fields=id,name", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
               print(error)
            } else {
               print(result)
//               let resultDict = result as! NSDictionary
//               let data = resultDict.objectForKey("data") as! NSArray
//               print(data)
            }
         })
      }
   }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facebookCell", forIndexPath: indexPath)


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
