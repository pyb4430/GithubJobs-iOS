//
//  GithubApiManager.swift
//  GithubJobs
//
//  Created by Taylor Harrison on 10/29/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

class GithubApiManager {
    
    let jobsUrl: String = "https://jobs.github.com/positions.json?description=python"
    
    var jobTitles = [String]()
    var jobCompanies = [String]()
    
    func getJobs(setDataFunction: (Array<Job>) -> Void){
        let url = NSURL(string: jobsUrl)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            var jobArray = [Job]()
            var json: Array<AnyObject>!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? Array<AnyObject>
            } catch {
                print(error)
            }
            
            print("how many jobs?: \(json.count)")
            for job in json! {
                guard let jobsJson = job as? [String: AnyObject],
                let title = jobsJson["title"] as? String,
                let company = jobsJson["company"] as? String,
                let description = jobsJson["description"] as? String else {
                    print("error reading job: \(jobArray.count)")
                    continue
                }
                let companyLogoUrl = jobsJson["company_logo"] as? String
                if(companyLogoUrl != nil) {
                    jobArray.append(Job(title: title, company: company, description: description, companyLogoUrl:companyLogoUrl!))
                } else {
                    jobArray.append(Job(title: title, company: company, description: description, companyLogoUrl: ""))
                }
                print(title + " " + company)
            }
            
            setDataFunction(jobArray)
        }
        
        task.resume()
        
    }
    
    
}
