//
//  DetailViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 11/5/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var companyUrl: UILabel!

    var job: Job?
    @IBOutlet weak var jobDescriptionDetails: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let job = job else {
            return
        }
        
        company.text = job.company
        jobTitle.text = job.title
        jobDescriptionDetails.loadHTMLString(job.jobDescription, baseURL: nil)
        companyUrl.text = job.rawCompanyUrl
    }
    
    @IBAction func handleUrlClick(recognizer: UITapGestureRecognizer) {
        if let url = job?.companyUrl {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
}
