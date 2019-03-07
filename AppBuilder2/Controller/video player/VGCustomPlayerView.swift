//
//  VGCustomPlayerView.swift
//  VGPlayerExample
//
//  Created by Vein on 2017/6/12.
//  Copyright © 2017年 Vein. All rights reserved.
//

import UIKit
import VGPlayer

class VGCustomPlayerView: VGPlayerView {
    
    var switchingFlag = "1"
    let dropDown = DropDown()
    var playRate : Float = 1.0
    let rateButton = UIButton(type: .custom)
    let bottomProgressView : UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = #colorLiteral(red: 0.4980392157, green: 0.7215686275, blue: 0.3019607843, alpha: 1)
        progress.isHidden = true
        return progress
    }()
    var subtitles : VGSubtitles?
    let subtitlesLabel = UILabel()
    let mirrorFlipButton = UIButton(type: .custom)
    
    override func configurationUI() {
        
        super.configurationUI()
        
        self.titleLabel.removeFromSuperview()
        if (UserDefaults.standard.string(forKey: "VideoPogresColor") != nil) {
            self.timeSlider.minimumTrackTintColor = UIColor().HexToColor(hexString: UserDefaults.standard.string(forKey: "VideoPogresColor")!)
        }else {
           self.timeSlider.minimumTrackTintColor = #colorLiteral(red: 0.4980392157, green: 0.7215686275, blue: 0.3019607843, alpha: 1)
        }
        self.topView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6542701199)
        self.bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.closeButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.topView.addSubview(rateButton)
        
        if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "1" {
            self.closeButton.isHidden = true
            rateButton.snp.makeConstraints { (make) in
                //make.centerX.equalTo(closeButton.snp.right).offset(-18)
                make.centerY.equalTo(closeButton).offset(-10)
                make.right.equalTo(self.snp.right).offset(-7)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }else if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "3"{
            self.closeButton.isHidden = true
            rateButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(closeButton).offset(-10)
                make.right.equalTo(self.snp.right).offset(-7)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }else {
            self.closeButton.isHidden = false
            rateButton.snp.makeConstraints { (make) in
                //make.centerX.equalTo(closeButton.snp.right).offset(25)
                make.centerY.equalTo(closeButton)
                make.right.equalTo(self.snp.right).offset(-7)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }
        self.audioVideoSwicthBtn.isHidden = false
        self.rateButton.isHidden = false
        rateButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        rateButton.titleLabel?.textAlignment = NSTextAlignment.center
        rateButton.setBackgroundImage(#imageLiteral(resourceName: "WhiteCirle"), for: .normal)
        rateButton.setTitle("1x", for: .normal)
        rateButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 10.0)
        rateButton.addTarget(self, action: #selector(onRateButton), for: .touchUpInside)
        
        self.addSubview(bottomProgressView)
        bottomProgressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(3)
        }
        
        mirrorFlipButton.tintColor = UIColor.black
        mirrorFlipButton.setTitle("Turn on mirroring", for: .normal)
        mirrorFlipButton.setTitle("Turn off mirroring", for: .selected)
        mirrorFlipButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 14.0)
        mirrorFlipButton.addTarget(self, action: #selector(onMirrorFlipButton(_:)), for: .touchUpInside)
        self.topView.addSubview(mirrorFlipButton)
        mirrorFlipButton.snp.makeConstraints { (make) in
            make.right.equalTo(rateButton.snp.left).offset(-10)
            make.centerY.equalTo(closeButton)
        }
        mirrorFlipButton.isHidden = true
        
        subtitlesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        subtitlesLabel.numberOfLines = 0
        subtitlesLabel.textAlignment = .center
        subtitlesLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subtitlesLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5031571062)
        subtitlesLabel.adjustsFontSizeToFitWidth = true
        self.insertSubview(subtitlesLabel, belowSubview: self.bottomView)
        
        subtitlesLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(snp.bottom).offset(-10)
            make.centerX.equalTo(self)
        }
        
        let tapGestureForView = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tapGestureForView.numberOfTapsRequired = 1
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(tapGestureForView)
        
        /*/NewChange
        self.addSubview(imageThumbnailForVideo)
        imageThumbnailForVideo.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
        self.sendSubview(toBack: imageThumbnailForVideo)*/
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer){
        //print("view Tapped")
        super.displayControlView(false)
    }
    
    override func playStateDidChange(_ state: VGPlayerState) {
        super.playStateDidChange(state)
        //print("playRate" ,playRate)
        if state == .playing || state == .playFinished  {
            self.vgPlayer?.player?.rate = playRate
            self.vgPlayer?.play()
        }
    }
    
    override func displayControlView(_ isDisplay: Bool) {
        super.displayControlView(isDisplay)
        //self.bottomProgressView.isHidden = isDisplay
        self.bottomProgressView.isHidden = true
        if !isDisplay {
            dropDown.hide()
        }
    }
    
    override func reloadPlayerView() {
        super.reloadPlayerView()
        //self.playRate = 1.0
        //self.rateButton.setTitle("1x", for: .normal)
        self.playRate = UserDefaults.standard.float(forKey: "PlayerRate")
        //self.rateButton.setTitle("\(Int(UserDefaults.standard.float(forKey: "PlayerRate")))x", for: .normal)
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
        let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
        self.rateButton.setTitle(strValueCurrent, for: .normal)
    }
    
    override func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        super.playerDurationDidChange(currentDuration, totalDuration: totalDuration)
        if let sub = self.subtitles?.search(for: currentDuration) {
            self.subtitlesLabel.isHidden = false
            self.subtitlesLabel.text = sub.content
        } else {
            self.subtitlesLabel.isHidden = true
        }
        self.bottomProgressView.setProgress(Float(currentDuration/totalDuration), animated: true)
    }
    
    open func setSubtitles(_ subtitles : VGSubtitles) {
        //self.subtitles = subtitles
    }
    
    @objc func onRateButton() {
        
        let arryOfSize = ["1x","1.25x","1.5x","1.75x","2x"] //,"2.5x","3x"
        dropDown.dataSource = arryOfSize
        dropDown.selectionAction = { [unowned self] (index , item) in
            var strValue = item
            strValue = strValue.replacingOccurrences(of: "x", with: "")
            self.rateButton.setTitle(item, for: .normal)
            self.playRate = Float(strValue)!
            self.playButtion.isSelected = false
            self.playButtion.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.vgPlayer?.player?.rate = Float(strValue)!
            UserDefaults.standard.set(self.playRate, forKey: "PlayerRate")
        }
        
        dropDown.anchorView = rateButton
        dropDown.width = 70
        dropDown.bottomOffset = CGPoint(x: 0, y:30)
        dropDown.backgroundColor = UIColor().HexToColor(hexString: "#2B292B")//UIColor.white
        dropDown.textColor = UIColor.white
        
        if dropDown.isHidden{
            dropDown.show()
        } else{
            dropDown.hide()
        }
    }
    
    @objc func onMirrorFlipButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), -1, 1, 1)
        } else {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), 1, 1, 1)
        }
        updateDisplayerView(frame: self.bounds)
    }
    
    //NewChange
    open var imageThumbnailForVideo : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.clear
        img.contentMode = UIViewContentMode.scaleAspectFit
        return img
    }()
}
