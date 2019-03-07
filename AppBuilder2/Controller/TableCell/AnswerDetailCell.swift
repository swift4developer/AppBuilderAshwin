//
//  AnswerDetailCell.swift
//  AppBuilder2
//
//  Created by Aditya on 13/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
class AnswerDetailCell: MGSwipeTableCell {

    //MARK:- Question CELL
    @IBOutlet weak var imgUserQuestion: RoundedImageView!
    
    @IBOutlet weak var lblTimeQuestion: UILabel!
    @IBOutlet weak var btnAudioResponseQuestion: UIButton!
    @IBOutlet weak var imgPlayQuestion: UIImageView!
    @IBOutlet weak var imgAudioQuestion: UIImageView!
    @IBOutlet weak var viewAudioQuestionConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAudioQuestion: CustomView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblUsernameQuestion: UILabel!
    
    
    // MARK:- Answer CELL
    
    @IBOutlet weak var viewAudioAnswerConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgUserAnswer: RoundedImageView!
    @IBOutlet weak var lblTimeAnswer: UILabel!
    @IBOutlet weak var btnAudioAnswer: UIButton!
    @IBOutlet weak var imgPlayAnswer: UIImageView!
    @IBOutlet weak var imgAudioAnswer: UIImageView!
    @IBOutlet weak var viewAudioAnswer: CustomView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblUsernameAnswer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
