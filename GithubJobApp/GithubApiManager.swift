//
//  GithubApiManager.swift
//  GithubJobs
//
//  Created by Taylor Harrison on 10/29/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import CoreLocation

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
                guard let jobs = data else {
                    print("no data recieved")
                    return
                }
                print(NSString(data: jobs, encoding: NSUTF8StringEncoding))
                
                var jobArray = [Job]()
                let json: [AnyObject]?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(jobs, options: NSJSONReadingOptions()) as? [AnyObject]
                    
                    if let json = json {
                        print("how many jobs?: \(json.count)")
                        for job in json {
                            guard let jobJson = job as? [String: AnyObject] else {
                                print("error reading job: \(jobArray.count)")
                                continue
                            }
                            
                            jobArray.append(Job(withDictionary: jobJson))
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.jobsRetrieved(jobArray)
                    }
                } catch {
                    print(error)
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
}
