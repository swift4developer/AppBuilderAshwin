//
//  CourseHeaderTableViewCell.swift
//  AppBuilder2
//
//  Created by Aditya on 01/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class CourseHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imgDropdown: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
