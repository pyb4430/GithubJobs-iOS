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

    var jobRealm: JobRealm?
    var webViewController: WebViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let jobRealm = jobRealm else {
            return
        }
        
        company.text = jobRealm.jobDescription
        jobTitle.text = jobRealm.title
        companyUrl.text = jobRealm.rawCompanyUrl
    }
    
    @IBAction func handleUrlClick(recognizer: UITapGestureRecognizer) {
        if let url = jobRealm?.companyUrl {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let webViewController = segue.destinationViewController as? WebViewController {
            self.webViewController = webViewController
            print("segue to webview with job description dawg")
            webViewController.jobRealm = self.jobRealm
        }
    }
}

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView?
    var jobRealm: JobRealm?
    
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
        if let jobRealm = jobRealm {
            webView?.loadHTMLString(jobRealm.jobDescription, baseURL: nil)
        }
    }
}


