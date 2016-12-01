//
//  GithubApiManager.swift
//  GithubJobs
//
//  Created by Taylor Harrison on 10/29/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

struct GithubApiManager {
    
    private let jobsUrl: String = "https://jobs.github.com/positions.json?description=swift"
    
    func getJobs(completion: ([Job]) -> Void) {
        if let url = NSURL(string: jobsUrl) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                guard let jobs = data else {
                    print("error: data recieved is invalid")
                    return
                }
                print(NSString(data: jobs, encoding: NSUTF8StringEncoding))
                
                var jobArray = [Job]()
                let json: Array<AnyObject>?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(jobs, options: NSJSONReadingOptions()) as? Array<AnyObject>
                    
                    if let json = json {
                        print("how many jobs?: \(json.count)")
                        for job in json {
                            guard let jobJson = job as? [String: AnyObject] else {
                                print("error reading job: \(jobArray.count)")
                                continue
                            }
                            
                            jobArray.append(Job(jsonJobDictionary: jobJson))
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        completion(jobArray)
                    }
                } catch {
                    print(error)
                }
                
                
            }
        task.resume()
        }
    }
}
