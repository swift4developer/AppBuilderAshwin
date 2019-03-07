//
//  QATableViewCell.swift
//  AppBuilder2
//
//  Created by Aditya on 07/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class QATableViewCell: MGSwipeTableCell {

    //MARK:- Question Cell USER
    @IBOutlet weak var imgViewIndicator: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUser: RoundedImageView!
    @IBOutlet weak var lblQuestionType: RoundedLbl!
    @IBOutlet weak var viewMarkRead: UIView!
    @IBOutlet weak var btnMarkRead: UIButton!
    @IBOutlet weak var veiwReply: UIView!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var markReadConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteConstraint: NSLayoutConstraint!
    @IBOutlet weak var editConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyConstraint: NSLayoutConstraint!
    
    //MARK:- Answer Cell USER
    @IBOutlet weak var audioView: CustomView!
    @IBOutlet weak var viewSideLine: UIView!
    @IBOutlet weak var audioViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAnswerConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnPlayAudio: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblAnswer: UILabel!
    
    @IBOutlet var stackViewToMoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAddAnswer: UIButton!
    @IBOutlet weak var btnAddAudio: UIButton!
    @IBOutlet weak var btnMoreToLabelConstraint: NSLayoutConstraint!
    @IBOutlet  var stackViewTopConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var viewOfAdminAddAudio: CustomView!
    @IBOutlet weak var viewOfAdminAddAns: CustomView!
    
    @IBOutlet weak var heightOfViewofline: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
