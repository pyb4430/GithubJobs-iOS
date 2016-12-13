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
    
    var jobArray = [Job]()
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
//        loadJobs() {jobs in
//            if let jobs = jobs {
//                self.jobsRetrieved(jobs)
//            }
//            self.searchBar?.text = NSUserDefaults.standardUserDefaults().stringForKey(GithubApiManager.SearchQueryUserDefaultKey)
//        }
        
        loadJobsRealm() {jobs in
            if let jobs = jobs {
                self.jobsRetrievedRealm(jobs)
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
//        return jobArray.count
        return jobArrayRealm.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }

//        cell.job = jobArray[indexPath.row]
        cell.jobRealm = jobArrayRealm[indexPath.row]
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
//            detailViewController.job = jobArray[indexPath.row]
            detailViewController.jobRealm = jobArrayRealm[indexPath.row]
            
            let jobRealm = jobArrayRealm[indexPath.row]
            
            RealmController.getRealmConfig(Config.RealmURL, realmName: Config.RealmJobViewHistory) { config in
                let realm = RealmController.getRealm(config)
                
                try! realm.write {
                    let jr = JobRealm(value: ["title": jobRealm.title, "jobDescription": jobRealm.jobDescription, "company": jobRealm.company, "id": jobRealm.id])
                    jr.rawCompanyLogoUrl = jobRealm.rawCompanyLogoUrl
                    jr.rawCompanyUrl = jobRealm.rawCompanyUrl
                    realm.add(jr)
                }
            }
        }
    }
    
    func jobsRetrieved(jobs: [Job]) {
        jobArray = jobs
        tableView.reloadData()
//        saveJobs()
        saveJobsRealm()
    }
    
    func jobsRetrievedRealm(jobs: [JobRealm]) {
        jobArrayRealm = jobs
        tableView.reloadData()
//        saveJobs()
        saveJobsRealm()
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
    
    func saveJobsRealm() {
        let realm = RealmController.getRealm()
        let jobs = jobArrayRealm.map({$0})
        let jobCache = JobViewHistory(value: ["jobs": jobs])
        jobCache.id = Config.JobCacheID
        try! realm.write {
            print("jobs cached in realm")
            realm.create(JobViewHistory.self, value: jobCache, update: true)
        }
    }
    
    func loadJobsRealm(completion: ([JobRealm]?) -> Void) {
        let realm = RealmController.getRealm()
        let jobViewHistory = realm.objects(JobViewHistory.self)
        completion(jobViewHistory.first?.jobs.map({$0}))
        print("jobs loaded from realm cache")
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
