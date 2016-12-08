//
//  Config.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/7/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation

enum Config {
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let JobArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("jobs")
}
