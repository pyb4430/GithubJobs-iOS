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
    
    init(title: String, company: String, description: String, companyLogoUrl: String? = nil, companyUrl: String? = nil) {
        self.company = company
        self.title = title
        self.companyLogoUrl = companyLogoUrl
        self.description = description
        self.companyUrl = companyUrl
    }
}
