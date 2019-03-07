//
//  CourseDetailCell.swift
//  AppBuilder2
//
//  Created by Aditya on 01/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class CourseDetailCell: UITableViewCell {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewOfArrow: UIView!
    @IBOutlet weak var viewOfVerticalIndicatore: UIView!
    
    
    //Select lagguage outlets
    @IBOutlet weak var imgOfSelectn: UIImageView!
    @IBOutlet weak var lblOfLangugeName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
