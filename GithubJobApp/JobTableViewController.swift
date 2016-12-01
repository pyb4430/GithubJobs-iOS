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
            self.tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }

        cell.job = jobArray[indexPath.row]
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController,
            let row = self.tableView.indexPathForSelectedRow {
            detailViewController.job = jobArray[row.row]
        }
    }
}
