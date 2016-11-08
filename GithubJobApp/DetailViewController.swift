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
    
    // MARK: Properties

    var job: Job
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        job = Job(title: "", company: "", description: "", companyLogoUrl: "")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        job = Job(title: "", company: "", description: "", companyLogoUrl: "")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrStr = try! NSMutableAttributedString(
            data: job.description.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 10.0)! ]
        
        attrStr.addAttributes(myAttribute, range: NSMakeRange(0, attrStr.length))
        
        company.text = job.company
        jobTitle.text = job.title
        jobDescriptionScroll.attributedText = attrStr
        jobDescriptionScroll.setContentOffset(CGPointZero, animated: false)
    }
    
}
