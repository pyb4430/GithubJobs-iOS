//
//  JobBookmarkTableViewController.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/8/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit
import RealmSwift

class JobBookmarkTableViewController: UITableViewController {

    var jobs: [JobRealm]?
    var jobResults: Results<JobRealm>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        RealmController.getRealmConfig(Config.RealmURL, realmName: Config.RealmJobViewHistory) { config in
            let realm = RealmController.getRealm(config)
            
            self.jobResults = realm.objects(JobRealm)
            self.tableView.reloadData()
            print("job history table reloaded")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobResults?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell") as! JobTableViewCell
        cell.jobRealm = jobResults?[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            print("wheres my job description dawg")
            if let result = jobResults?[indexPath.row] {
                print("i gotchu a job dawg : \(result.jobDescription)")
            } else {
                print("no job for you")
            }
            detailViewController.jobRealm = jobResults?[indexPath.row]
        }
    }
}
