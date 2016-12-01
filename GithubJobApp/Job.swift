//
//  Job.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

struct Job {
    let company: String
    let title: String
    let companyLogoUrl: String?
    let companyUrl: String?
    let description: String
    
    init(jsonJobDictionary: [String: AnyObject]) {
        company = jsonJobDictionary["company"] as? String ?? ""
        title = jsonJobDictionary["title"] as? String ?? ""
        description = jsonJobDictionary["description"] as? String ?? ""
        companyLogoUrl = jsonJobDictionary["company_logo"] as? String
        companyUrl = jsonJobDictionary["company_url"] as? String
    }
}
