//
//  Job.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

class Job: NSObject, NSCoding {
    var company: String
    var title: String
    var rawCompanyLogoUrl: String?
    var rawCompanyUrl: String?
    var jobDescription: String
    var companyLogoUrl: NSURL? {
        return NSURL(string: rawCompanyLogoUrl ?? "")
    }
    var companyUrl: NSURL? {
        return NSURL(string: rawCompanyUrl ?? "")
    }
    
    init(withDictionary aDict: [String: AnyObject]) {
        company = aDict["company"] as? String ?? ""
        title = aDict["title"] as? String ?? ""
        jobDescription = aDict["description"] as? String ?? ""
        rawCompanyLogoUrl = aDict["company_logo"] as? String
        rawCompanyUrl = aDict["company_url"] as? String
    }
    
    init(company: String, title: String, jobDescription: String, companyLogoURL: String?, companyURL: String?) {
        self.company = company
        self.title = title
        self.jobDescription = jobDescription
        self.rawCompanyLogoUrl = companyLogoURL
        self.rawCompanyUrl = companyURL
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(company, forKey: JobPropertyKey.companyKey)
        aCoder.encodeObject(title, forKey: JobPropertyKey.titleKey)
        aCoder.encodeObject(jobDescription, forKey: JobPropertyKey.jobDescriptionKey)
        aCoder.encodeObject(rawCompanyLogoUrl, forKey: JobPropertyKey.companyLogoURLKey)
        aCoder.encodeObject(rawCompanyUrl, forKey: JobPropertyKey.companyURLKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let company = aDecoder.decodeObjectForKey(JobPropertyKey.companyKey) as! String
        let title = aDecoder.decodeObjectForKey(JobPropertyKey.titleKey) as! String
        let jobDescription = aDecoder.decodeObjectForKey(JobPropertyKey.jobDescriptionKey) as! String
        let rawCompanyLogoUrl = aDecoder.decodeObjectForKey(JobPropertyKey.companyLogoURLKey) as! String?
        let rawCompanyUrl = aDecoder.decodeObjectForKey(JobPropertyKey.companyURLKey) as! String?
        self.init(company: company, title: title, jobDescription: jobDescription, companyLogoURL: rawCompanyLogoUrl, companyURL: rawCompanyUrl)
    }
}

struct JobPropertyKey {
    static let companyKey = "company"
    static let titleKey = "title"
    static let companyLogoURLKey = "company_logo_url"
    static let companyURLKey = "company_url"
    static let jobDescriptionKey = "job_decription"
}
