//
//  VideoDetailCell.swift
//  AppBuilder2
//
//  Created by Aditya on 06/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class VideoDetailCell: UITableViewCell {

    
    //MARK:- sectioHeader
    
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var lblSectionSubtitle: UILabel!
    
    //MARK:- rowHeader
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var heightOfHeader: NSLayoutConstraint!
    @IBOutlet weak var lblOfflineSectionTitle: UILabel!

    
    //MARK:- rowCell
    @IBOutlet weak var lblNUmber: UILabel!
    @IBOutlet weak var lblRowTitle: UILabel!
    @IBOutlet weak var lblRowSubtitle: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var lblOfFileNotFound: UILabel!
    @IBOutlet weak var heightOfFileNotFound: NSLayoutConstraint!
    
    @IBOutlet weak var imgOfCmpletDownld: UIImageView!
    @IBOutlet weak var xPstnOfrowTitle: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgDownload: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
