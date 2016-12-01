//
//  JobTableViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit

class JobTableViewController: UITableViewController {
    
    var jobArray = [Job]()
    var companyLogoCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiManager: GithubApiManager = GithubApiManager()
        apiManager.getJobs() {(data) in
            self.jobArray = data
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        let job = jobArray[indexPath.row]

        cell.company.text = job.company
        cell.title.text = job.title
        let logoImageView = cell.companyLogo as! UIImageView
        logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        if let actualCompanyLogoUrl = job.companyLogoUrl {
            if self.companyLogoCache.objectForKey(actualCompanyLogoUrl) != nil, let logoAnyObject = companyLogoCache.objectForKey(actualCompanyLogoUrl), let logoImg = logoAnyObject as? UIImage {
                print("using cached image")
                logoImageView.image = logoImg
            } else {
                print("actualCompanyLogoUrl: " + actualCompanyLogoUrl + "\n")
                
                if let imgUrl = NSURL(string: actualCompanyLogoUrl) {
                    let task = NSURLSession.sharedSession().dataTaskWithURL(imgUrl) {(data, response, error) in
                        if error == nil {
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                if let actualData = data, logoImage = UIImage(data: actualData) {
                                    logoImageView.image = logoImage
                                    self.companyLogoCache.setObject(logoImage, forKey: actualCompanyLogoUrl as AnyObject)
                                }
                            }
                        } else {
                            if let actualError = error { print("error: \(actualError) \n") }
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                logoImageView.image = UIImage(named: "logo_placeholder")
                                
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        return cell
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Detail View") {
            if let detailViewController = segue.destinationViewController as? DetailViewController,
                let row = self.tableView.indexPathForSelectedRow {
                detailViewController.job = jobArray[row.row]
            }
        }
    }
    
    deinit {
        companyLogoCache.removeAllObjects()
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
