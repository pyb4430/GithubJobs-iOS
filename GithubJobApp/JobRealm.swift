//
//  JobRealm.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/10/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON

class JobRealm: Object {
    dynamic var company: String = ""
    dynamic var title: String = ""
    dynamic var id: String = ""
    dynamic var jobDescription: String = ""
    dynamic var rawCompanyLogoUrl: String? = nil
    dynamic var rawCompanyUrl: String? = nil
    
    var companyLogoUrl: NSURL? {
        return NSURL(string: rawCompanyLogoUrl ?? "")
    }
    var companyUrl: NSURL? {
        return NSURL(string: rawCompanyUrl ?? "")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.company = json["company"].string ?? ""
        self.title = json["title"].string ?? ""
        self.jobDescription = json["description"].string ?? ""
        self.rawCompanyLogoUrl = json["company_logo"].string
        self.rawCompanyUrl = json["company_url"].string
        self.id = json["id"].string ?? ""
    }
}

class JobViewHistory: Object {
    let jobs = List<JobRealm>()
    dynamic var id: Int32 = 1

    override static func primaryKey() -> String? {
        return "id"
    }
}

