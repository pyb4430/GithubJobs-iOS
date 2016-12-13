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
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmController.getRealmConfig(Config.RealmURL, realmName: Config.RealmJobViewHistory) { config in
            let realm = RealmController.getRealm(config)
            
            self.notificationToken = realm.addNotificationBlock() { notification, realm in
                self.jobResults = realm.objects(JobRealm)
                self.tableView.reloadData()
                print("realm says update the job view history")
            }
            
            self.jobResults = realm.objects(JobRealm)
            self.tableView.reloadData()
            print("job history table reloaded")
        }
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            detailViewController.jobRealm = jobResults?[indexPath.row]
        }
    }
}
