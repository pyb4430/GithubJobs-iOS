//
//  GithubApiManager.swift
//  GithubJobs
//
//  Created by Taylor Harrison on 10/29/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import RealmSwift

final class TaskList: Object {
    dynamic var text = ""
    dynamic var id = ""
    let items = List<Task>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Task: Object {
    dynamic var text = ""
    dynamic var completed = false
}

class GithubApiManager: NSObject, CLLocationManagerDelegate {
    
    private static let baseURL: String = "https://jobs.github.com/positions.json"
    static let SearchQueryUserDefaultKey = "search_query"
    
    var delegate: GithubAPIDelegate?
    
    var locationManager: CLLocationManager?
    
    var searchQuery: String?
    
    func getJobs(searchQuery query: String?) {
        self.searchQuery = query
        print("authorization status: \(CLLocationManager.authorizationStatus().rawValue)")
        switch(CLLocationManager.authorizationStatus()) {
            case .Restricted, .Denied:
                locationManager = nil
                getJobsFromAPI(searchQuery: searchQuery)
            case .NotDetermined:
                print("prompting user for location services permission")
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
            default:
                if locationManager == nil {
                    locationManager = CLLocationManager()
                    locationManager?.delegate = self
                    locationManager?.startMonitoringSignificantLocationChanges()
                } else {
                    getJobsFromAPI(searchQuery: searchQuery)
                }
        }
    }
    
    func getJobsFromAPI(searchQuery query: String?) {        
        if let url = generateURL(searchQuery, locationCoordinates: locationManager?.location?.coordinate) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {data, _, error in
                if let error = error {
                    print("error in jobs retrieval: \(error.domain)")
                    return
                }
                guard let jobsData = data else {
                    print("no data recieved")
                    return
                }
                print(NSString(data: jobsData, encoding: NSUTF8StringEncoding))
                
                
                
                
                
//                SyncUser.logInWithCredentials(.usernamePassword("taylor@oakcity.io", password: "Goos?fraBa84!7", register: false), authServerURL: NSURL(string: "http://127.0.0.1:9080")!, onCompletion: { user, error in
//                    
//                    guard let user = user else {
//                        fatalError(String(error))
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        print("configuring realm... ")
//                        let configuration = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: NSURL(string: "realm://127.0.0.1:9080/~/job_view_history")!))
//                    
//                        let realm = try! Realm(configuration: configuration)
//                        
//                        let jobViewHistory = realm.objects(JobViewHistory.self)
//
//                        print("writing to realm...")
//                        try! realm.write {
//                            let json = try! NSJSONSerialization.JSONObjectWithData(jobsData, options: [])
//                            
//                            if(jobViewHistory.count < 1) {
//                                print("creating jobViewHistory")
//                                realm.create(JobViewHistory.self, value: JobViewHistory(), update: false)
//                            } else {
//                                print("jobViewHistory not empty: \(jobViewHistory.count)" )
//                                let jobR = JobRealm()
//                                jobR.company = "woo"
//                                jobR.title = "hist"
//                                jobViewHistory.first?.jobs.append(jobR)
//                            }
////                            realm.create(JobRealm.self, value: json[0], update: false)
////                            realm.objects(TaskList.self).first?.items.append(Task(value: ["text": "githubjobs task3"]))
////                            realm.create(JobRealmd.self, value: JobRealm(), update: true)
////                            let jobR = JobRealm()
////                            jobR.company = "hey"
////                            jobR.title = "sup realm"
////                            realm.add(jobR)
//                        }
////                        print("realm job? : \(realm.objects(TaskList.self).first?.company)")
//                    }
//                })
                
                let jsonJobs = JSON(data: jobsData)
                let jobArray = jsonJobs.arrayValue.map({Job(json: $0)})
                let jobArrayRealm = jsonJobs.arrayValue.map({JobRealm(json: $0)})
            
                dispatch_async(dispatch_get_main_queue()) {
//                    self.delegate?.jobsRetrieved(jobArray)
                    self.delegate?.jobsRetrievedRealm(jobArrayRealm)
                }
            }
            task.resume()
        }
    }
    
    func generateURL(searchQuery: String?, locationCoordinates: CLLocationCoordinate2D?) -> NSURL? {
        let urlComps = NSURLComponents(string: GithubApiManager.baseURL)
        var queryItems = [NSURLQueryItem]()
        queryItems.append(NSURLQueryItem(name: "description", value: searchQuery))
        queryItems.append(NSURLQueryItem(name: "lat", value: locationCoordinates?.latitude.description))
        queryItems.append(NSURLQueryItem(name: "lon", value: locationCoordinates?.longitude.description))
        urlComps?.queryItems = queryItems
        
        let finalUrl = urlComps?.URL
        if let rawUrl = finalUrl?.absoluteString {
            print("raw url: " + rawUrl)
        }
        
        return finalUrl
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("authorization status changed")
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            manager.requestLocation()
        default:
            getJobsFromAPI(searchQuery: searchQuery)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdatelocations")
        getJobsFromAPI(searchQuery: searchQuery)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("location failed with error: \(error.domain) \(error.code)")
        getJobsFromAPI(searchQuery: searchQuery)
    }
}

protocol GithubAPIDelegate {
    func jobsRetrieved(jobs: [Job]) -> Void
    func jobsRetrievedRealm(jobs: [JobRealm]) -> Void
}


