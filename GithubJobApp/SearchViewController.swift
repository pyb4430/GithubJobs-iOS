//
//  SearchViewController.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/5/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let jobTableViewcontroller = segue.destinationViewController as? JobTableViewController {
            jobTableViewcontroller.searchBar = self.searchBar
        }
    }
}