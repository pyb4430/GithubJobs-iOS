//
//  JobTableViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit
import RealmSwift

class JobTableViewController: UITableViewController, GithubAPIDelegate, UISearchBarDelegate {
    
    var jobArrayRealm = [JobRealm]()
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
        
        loadJobsRealm() {jobs in
            if let jobs = jobs {
                self.jobsRetrievedRealm(jobs, shouldSave: false)
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
        return jobArrayRealm.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }

        cell.jobRealm = jobArrayRealm[indexPath.row]
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            detailViewController.jobRealm = jobArrayRealm[indexPath.row]
            
            let jobRealm = jobArrayRealm[indexPath.row]
            
            RealmController.getRealmConfig(Config.RealmURL, realmName: Config.RealmJobViewHistory) { config in
                let realm = RealmController.getRealm(config)
                
                do {
                    try realm.write {
                        realm.add(jobRealm.clone(), update: true)
                    }
                } catch {
                    print("unable to save job in history")
                }
            }
        }
    }
    
    func jobsRetrievedRealm(jobs: [JobRealm], shouldSave: Bool) {
        jobArrayRealm = jobs
        tableView.reloadData()
        if(shouldSave) {
            saveJobsRealm()
        }
    }
    
    func saveJobsRealm() {
        let realm = RealmController.getRealm()
        let jobs = jobArrayRealm.map({$0})
        let jobCache = JobViewHistory(value: ["jobs": jobs])
        jobCache.id = Config.JobCacheID
        
        do {
            try realm.write {
                print("jobs cached in realm")
                realm.create(JobViewHistory.self, value: jobCache, update: true)
            }
        } catch {
            print("unable to cache jobs in realm")
        }
    }
    
    func loadJobsRealm(completion: ([JobRealm]?) -> Void) {
        let realm = RealmController.getRealm()
        let jobViewHistory = realm.objects(JobViewHistory.self)
        completion(jobViewHistory.first?.jobs.map({$0}))
        print("jobs loaded from realm cache")
    }
}
