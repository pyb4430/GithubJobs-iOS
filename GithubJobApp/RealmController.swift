//
//  RealmController.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/12/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmConfigCompletion = (Realm.Configuration) -> Void

struct RealmController {
    
    static func getRealmConfig(realmURL: String, realmName: String, completion: RealmConfigCompletion) {
        guard let url = NSURL(string: realmURL), let realmNameURL = NSURL(string: "realm://127.0.0.1:9080/~/\(realmName)") else {
            return
        }
        
        SyncUser.logInWithCredentials(.usernamePassword(Config.RealmUsername, password: Config.RealmPassword, register: false), authServerURL: url, onCompletion: { user, error in
        
            guard let user = user else {
                fatalError(String(error))
            }
            
            print("configuring realm... ")
            let configuration = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: realmNameURL), schemaVersion: Config.RealmSchemaVersion, deleteRealmIfMigrationNeeded: true)
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(configuration)
            }
        })
    }
    
    static func getRealm(config: Realm.Configuration) -> Realm {
        let realm = try! Realm(configuration: config)
        return realm
    }
    
    static func getRealm() -> Realm {
        let realm = try! Realm()
        return realm
    }
}
