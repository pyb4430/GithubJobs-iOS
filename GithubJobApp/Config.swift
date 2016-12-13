//
//  Config.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/7/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmMigrationBlock = (Migration, UInt64) -> Void

enum Config {
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let JobArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("jobs")
    
    static let JobCacheID: Int32 = 22
    
    //MARK: Realm URLs and credentials
    
    static let RealmURL = "http://127.0.0.1:9080"
    static let RealmJobViewHistory = "jobviewhistory"
    static let RealmUsername = "taylor@oakcity.io"
    static let RealmPassword = "Goos?fraBa84!7"
    
    // Realm migration block
    
    static let RealmSchemaVersion: UInt64 = 1
    
    static func realmMigrationBlock(migration: Migration, oldSchemaVersion: UInt64) {
        if (oldSchemaVersion < RealmSchemaVersion) {
            migration.deleteData("JobRealm")
        }
    }
}
