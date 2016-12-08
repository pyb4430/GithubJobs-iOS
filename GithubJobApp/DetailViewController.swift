//
//  DetailViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 11/5/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var companyUrl: UILabel!

    var job: Job?
    var webViewController: WebViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let job = job else {
            return
        }
        
        company.text = job.company
        jobTitle.text = job.title
        companyUrl.text = job.rawCompanyUrl        
    }
    
    @IBAction func handleUrlClick(recognizer: UITapGestureRecognizer) {
        if let url = job?.companyUrl {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let webViewController = segue.destinationViewController as? WebViewController {
            self.webViewController = webViewController
            webViewController.job = self.job
        }
    }
}

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView?
    var job: Job?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        webView?.navigationDelegate = self
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if(navigationAction.navigationType == .LinkActivated) {
            print("link activated")
            decisionHandler(WKNavigationActionPolicy.Cancel)
            if let url = navigationAction.request.URL, rawUrl = url.absoluteString {
                if(rawUrl.hasPrefix("http")) {
                    let svc = SFSafariViewController(URL: url)
                    self.presentViewController(svc, animated: true, completion:nil)
                }
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    override func viewDidLoad() {
        if let job = job {
            webView?.loadHTMLString(job.jobDescription, baseURL: nil)
        }
    }
}


