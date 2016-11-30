//
//  Job.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

struct Job {
    var company: String
    var title: String
    var companyLogoUrl: String?
    var description: String
    
    init(title: String, company: String, description: String, companyLogoUrl: String? = nil) {
        self.company = company
        self.title = title
        self.companyLogoUrl = companyLogoUrl
        self.description = description
    }
}
