//
//  DetailViewController.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 11/5/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDescriptionScroll: UITextView!
    @IBOutlet weak var companyUrl: UILabel!
    
    var job: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let job = job, let mutableStringData = job.description.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true), let attrStr = try? NSMutableAttributedString(
            data: mutableStringData,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else{
            return
        }
        
        if let uiFont = UIFont(name: "Helvetica", size: 10.0) {
            let myAttribute = [ NSFontAttributeName: uiFont]
            attrStr.addAttributes(myAttribute, range: NSMakeRange(0, attrStr.length))
        }
        
        company.text = job.company
        jobTitle.text = job.title
        jobDescriptionScroll.attributedText = attrStr
        jobDescriptionScroll.setContentOffset(CGPointZero, animated: false)
        companyUrl.text = job.companyUrl
    }
    
    @IBAction func handleUrlClick(recognizer: UITapGestureRecognizer) {
        if let job = job, let companyUrl = job.companyUrl, let companyNSURL = NSURL(string: companyUrl){
            UIApplication.sharedApplication().openURL(companyNSURL)
        }
    }
}
