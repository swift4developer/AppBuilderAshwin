//
//  TableViewCell.swift
//  AppBuilder2
//
//  Created by Aditya on 01/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    // MARK :- CELL1
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var lblLessonsDetails: UILabel!
    @IBOutlet weak var lblLessons: UILabel!
    @IBOutlet weak var lblTopicDetails: UILabel!
    @IBOutlet weak var lblTopics: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTtile: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblHoursDetails: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var viewCourseOverview: UIView!
    @IBOutlet weak var lblCourseOverView: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var hightofPorgressBgView: NSLayoutConstraint!
    @IBOutlet weak var btnMoreRead: UIButton!
    
    @IBOutlet weak var lblSubtitleBottomConstraint: NSLayoutConstraint!
    
    // ADDRESS
    @IBOutlet weak var lblHeaderAddress: UILabel!
    @IBOutlet weak var lblAddressFields: UILabel!
    @IBOutlet weak var lblRowAdress: UILabel!
    
    // MARK :- Help View Controller
    @IBOutlet weak var lblOfHelpVcCell: UILabel!
    @IBOutlet weak var lblOfHelpVcHeader: UILabel!
    @IBOutlet weak var btnOfHelpVcCell: UIButton!
    @IBOutlet weak var imgOfRightArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
