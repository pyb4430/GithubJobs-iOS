//
//  JobTableViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit

class JobTableViewController: UITableViewController, GithubAPIDelegate, UISearchBarDelegate {
    
    var jobArray = [Job]()
    var companyLogoCache = NSCache()
    
    lazy var apiManager: GithubApiManager = {
        let manager = GithubApiManager()
        manager.delegate = self
        return manager
    }()
    
    var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager = GithubApiManager()
        apiManager.delegate = self
        
        searchBar?.delegate = self
        loadJobs() {jobs in
            if let jobs = jobs {
                self.jobsRetrieved(jobs)
            }
            self.searchBar?.text = NSUserDefaults.standardUserDefaults().stringForKey(GithubApiManager.SearchQueryUserDefaultKey)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        apiManager.getJobs(searchQuery: searchBar.text!)
        searchBar.endEditing(false)
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
            let indexPath = self.tableView.indexPathForSelectedRow {
            detailViewController.job = jobArray[indexPath.row]
        }
    }
    
    func jobsRetrieved(jobs: [Job]) {
        jobArray = jobs
        tableView.reloadData()
        saveJobs()
    }
    
    // MARK: NSCoding
    
    func saveJobs() {
        dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.jobArray, toFile: Config.JobArchiveURL!.path!)
            if !isSuccessfulSave {
                print("Failed to save jobs")
            } else {
                print("jobs saved!")
                NSUserDefaults.standardUserDefaults().setObject(self.apiManager.searchQuery, forKey: GithubApiManager.SearchQueryUserDefaultKey)
            }
        }
    }
    
    func loadJobs(completion: ([Job]?) -> Void) {
        dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let path = Config.JobArchiveURL?.path {
                let jobs = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Job]
                dispatch_async(dispatch_get_main_queue()) {
                    completion(jobs)
                }
            }
        }
    }
}
