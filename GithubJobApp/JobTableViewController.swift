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
    var jobSelected: Job!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        //jobArray.append(Job(title: "testTitle", company: "testCompany", companyLogoUrl: ""))
        
        func setDataFunction(data: Array<Job>) {
            //print("set the data " + data[0].title)
            self.jobArray = data
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
            
        }
        
        let apiManager: GithubApiManager = GithubApiManager()
        apiManager.getJobs(setDataFunction)

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
        let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as? JobTableViewCell

        // Configure the cell...
        let job = jobArray[indexPath.row]

        cell?.company.text = job.company
        cell?.title.text = job.title
        (cell?.companyLogo as! UIImageView).contentMode = UIViewContentMode.ScaleAspectFit
        let imgUrl: NSURL = NSURL(string: job.companyLogoUrl)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(imgUrl) {(data, response, error) in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    (cell?.companyLogo as! UIImageView).image = UIImage(data: data!)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    (cell?.companyLogo as! UIImageView).image = UIImage(named: "logo_placeholder")
                }
            }
        }
        task.resume()
        return cell!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Detail View") {
            if let detailViewController = segue.destinationViewController as? DetailViewController,
                let row = self.tableView.indexPathForSelectedRow {
                detailViewController.job = jobArray[row.row]
            }
        }
    }
    

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        jobSelected = jobArray[indexPath.row]
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
