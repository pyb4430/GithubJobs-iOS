//
//  JobTableViewCell.swift
//  GithubJobApp
//
//  Created by Taylor Harrison on 10/31/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var company: UILabel!    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var job: Job? {
        didSet {
            guard let job = job else { return }
            company.text = job.company
            title.text = job.title
            companyLogo.setImgFromUrl(job.companyLogoUrl)
        }
    }
}

