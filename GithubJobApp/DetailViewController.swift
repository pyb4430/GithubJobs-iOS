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
    
    // MARK: Properties

    var job: Job?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let actualJob = job else {
            return
        }
        let attrStr = try! NSMutableAttributedString(
            data: actualJob.description.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 10.0)! ]
        
        attrStr.addAttributes(myAttribute, range: NSMakeRange(0, attrStr.length))
        
        company.text = actualJob.company
        jobTitle.text = actualJob.title
        jobDescriptionScroll.attributedText = attrStr
        jobDescriptionScroll.setContentOffset(CGPointZero, animated: false)
        companyUrl.text = actualJob.companyUrl
        
    }
    
    @IBAction func handleUrlClick(recognizer: UITapGestureRecognizer) {
        if let actualJob = job, let actualCompanyUrl = actualJob.companyUrl, let companyNSURL = NSURL(string: actualCompanyUrl){
            UIApplication.sharedApplication().openURL(companyNSURL)
        }
    }
    
    
}
