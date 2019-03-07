
//
//  HomeTableCell.swift
//  AppBuilder
//
//  Created by Apple on 01/01/18.
//  Copyright © 2018 Magneto. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Hoome Screen
    @IBOutlet weak var progreessView: UIProgressView!
    @IBOutlet weak var imgOfMenu: SquarBordeImageView!
    @IBOutlet weak var lblOftitle: UILabel!
    @IBOutlet weak var imgOfNotifiction: UIImageView!
    @IBOutlet weak var lblOfNotificationCount: PaddingLabel!
    @IBOutlet weak var lblOfDiscriptin: UILabel!
    @IBOutlet weak var lblOfProgresStatus: UILabel!
    
    
    // MARK: - Falg = 1
    @IBOutlet var viewBackGround: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblNameCell1: UILabel!
    @IBOutlet var lblBadgeCell1: UILabel!
    @IBOutlet var labelToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTopOfimg: UILabel!
    @IBOutlet var lblToViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblOfDscripation: UILabel!
    @IBOutlet weak var imgIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgOfNotifictn: UIImageView!
    
    @IBOutlet weak var widthOflblBadgeCell1: NSLayoutConstraint!
    @IBOutlet weak var widthOfimgOfNotifictn: NSLayoutConstraint!
    
    
    // MARK: - Falg = 0
    @IBOutlet var lblBadge2: UILabel!
    @IBOutlet var lblName2: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    
    // MARK: - SUB CATEGARY
    @IBOutlet var viewCell: viewOfShadow!
    @IBOutlet var imgSubIcon: UIImageView!
    @IBOutlet var imgLectureConstraint: NSLayoutConstraint!
    @IBOutlet var lblLectureConstraint: NSLayoutConstraint!
    @IBOutlet var imgHourConstraint: NSLayoutConstraint!
    @IBOutlet var lblHoursConstraint: NSLayoutConstraint!
    @IBOutlet var lblTitleSub: UILabel!
    @IBOutlet var lblLectures: UILabel!
    @IBOutlet var lblHours: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblSubDescription: UILabel!
    @IBOutlet var imgSubConstraint: NSLayoutConstraint!
    @IBOutlet var imgHours: UIImageView!
    @IBOutlet var imgLecture: UIImageView!
    
    //MARK: - LECTURE CELL
    @IBOutlet var lblLecture: UILabel!
    
    //MARK: - UNREAD CELL
    @IBOutlet var imgUserProfile: RoundedImageView!
    @IBOutlet var lblQuesDetails: UILabel!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var btnPlayQuestions: UIButton!
    @IBOutlet var progressViewQuestion: UIProgressView!
    
    //MARK: - ANSWERED CELL
    @IBOutlet var lblTutorName: UILabel!
    @IBOutlet var lblAnswer: UILabel!
    @IBOutlet var imgAnswerUser: RoundedImageView!
    @IBOutlet var btnPlayAudio: UIButton!
    @IBOutlet var lblPlayAudio: UILabel!
    
}
