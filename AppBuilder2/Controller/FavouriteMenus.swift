//
//  FavouriteMenus.swift
//  AppBuilder2
//
//  Created by VISHAL on 06/03/18.
//  Copyright © 2018 VISHAL WAGH. All rights reserved.
//

import UIKit
import Alamofire

protocol favMenuDelagte {
    func getSelectItem(SelecteItem : [String:Any])
    func homeBtnPress()
    func logOutBtnPress()
}

class FavouriteMenus: UIViewController {

    @IBOutlet weak var widthofHome: NSLayoutConstraint!
    @IBOutlet weak var widthOfFavView: NSLayoutConstraint!
    @IBOutlet weak var heightOfViewFavBgView: NSLayoutConstraint!
    @IBOutlet weak var viewofhome: UIView!
    @IBOutlet weak var MainBgViewOfFavMenus: UIView!
    @IBOutlet weak var viewofFavMenus: UIView!
    @IBOutlet weak var collectnViewOfFavMenus: UICollectionView!
    @IBOutlet weak var imgOfHome: UIImageView!
    @IBOutlet weak var lblOfHome: UILabel!
    @IBOutlet weak var btnOfHome: UIButton!
    @IBOutlet weak var btnOfLogOut: UIButton!
    @IBOutlet weak var imgOfLogOut: UIImageView!
    @IBOutlet weak var lblOfLogOut: UILabel!
    @IBOutlet weak var hightOfCollectionView: NSLayoutConstraint!
    
    @IBOutlet var bgViewOfAlert: UIView!
    @IBOutlet var viewOfAlert: UIView!
    @IBOutlet var lblOfLogutTitle: UILabel!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnYes: UIButton!
   
    @IBOutlet weak var topOfMainBgView: NSLayoutConstraint!
    
    var delegate : favMenuDelagte?
    var btnBack = UIButton()
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        if DeviceType.IS_IPHONE_x{
             topOfMainBgView.constant = 88
        }
        else{
             topOfMainBgView.constant = 64
        }
        
        let strngFlag = UserDefaults.standard.value(forKey: "paymentFlag")
        
        if strngFlag as? String == "1"{
            self.viewofhome.isHidden = true
            self.hightOfCollectionView.constant = 0
            self.widthOfFavView.constant = 150
            self.widthofHome.constant = 0
        }else {
            self.viewofhome.isHidden = false
            if self.appDelegate.arryFavMenuData.count <= 3 {
                self.hightOfCollectionView.constant = 100
            }else if self.appDelegate.arryFavMenuData.count == 0{
                self.hightOfCollectionView.constant = 0
            }else {
                self.hightOfCollectionView.constant = 205
            }
            self.widthOfFavView.constant = 270
            self.widthofHome.constant = 132.5
        }
        
        self.chache = NSCache()
        
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        btnBack.translatesAutoresizingMaskIntoConstraints = false;
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnBack.setImage(tintedImage, for: .normal)
        btnBack.addTarget(self,action: #selector(backClick(_:)), for: .touchUpInside)
        let widthConstraint1 = btnBack.widthAnchor.constraint(equalToConstant: 28)
        let heightConstraint1 = btnBack.heightAnchor.constraint(equalToConstant: 34)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        let backBarButtonitem = UIBarButtonItem(customView: btnBack)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lanuageConversion()
        getUIForFav()
        bgViewOfAlert.isHidden = true
        lblOfLogutTitle.text =  NSLocalizedString("Are you sure you want to logout?", comment: "")
    }
    
    @objc func backClick(_ sender: Any){
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: nil)
        }
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: nil)
            self.delegate?.homeBtnPress()
        }
    }
    
    @IBAction func btnLogtOutClick(_ sender: Any) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["logout"] as? String)!)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["logout_msg"] as? String)!)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        let btnYes = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["yes"] as? String)!, style: .default, handler: { action in
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
                self.callWSlogOut()
            }
        })
        
        let btnNo = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["no"] as? String)!, style: .default, handler: { action in
           
        })
        alertController.addAction(btnNo)
        alertController.addAction(btnYes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnDismissClick(_ sender: Any) {
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnNoClick(_ sender: Any) {
        bgViewOfAlert.isHidden = true
    }
    
    @IBAction func btnYesClick(_ sender: Any) {
        bgViewOfAlert.isHidden = true
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
            self.callWSlogOut()
        }
    }
    
    func getUIForFav() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    commonElement = common_element
                    let genarlSettings = commonElement["general_settings"] as! [String:Any]
                    let generalFont = genarlSettings["general_font"] as! Dictionary<String,String>
                   
                    let Fonttyle = generalFont["fontstyle"]
                    let txtcolorHex = generalFont["txtcolorHex"]
                    let fontSize = generalFont["size"]
                    let sizeInt:Int = Int(fontSize!)!
                    
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    lblOfHome.font = checkForFontType(fontStyle: Fonttyle!, fontSize: CGFloat(sizeInt))
                    lblOfHome.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    lblOfLogOut.font = checkForFontType(fontStyle: Fonttyle!, fontSize: CGFloat(sizeInt))
                    lblOfLogOut.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    
                    viewofFavMenus.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        
        if appDelegate.ArryLngResponeCustom != nil{
            self.lblOfHome.text = appDelegate.ArryLngResponeCustom!["home"] as? String
            self.lblOfLogOut.text = appDelegate.ArryLngResponeCustom!["logout"] as? String
        }
    }
}

//MARK:- UICollectionView Delegate
extension FavouriteMenus : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appDelegate.arryFavMenuData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavMenus", for: indexPath) as! CollectionViewCell
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        let generalFont = genarlSettings["general_font"] as! Dictionary<String,String>
        
        let Fonttyle = generalFont["fontstyle"]
        let txtcolorHex = generalFont["txtcolorHex"]
        
        let generalFontSize = genarlSettings["general_fontsize"] as! [String:Any]
        let fontSize = generalFontSize["small"] as! String
        let sizeInt:Int = Int(fontSize)!

        cell.lblOfMenuTitle.font = checkForFontType(fontStyle: Fonttyle!, fontSize: CGFloat(sizeInt))
        cell.lblOfMenuTitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
        
        let currentDic = self.appDelegate.arryFavMenuData[indexPath.row] as! [String:Any]
        
        if ((currentDic["title"] as? String) != nil){
            cell.lblOfMenuTitle.text = currentDic["title"] as? String
        }else {
            cell.lblOfMenuTitle.text = ""
        }
        
        let paymentFail = UserDefaults.standard.value(forKey: "paymentFlag") as! String
        
        if paymentFail == "1" {
            self.collectnViewOfFavMenus.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)
            cell.isUserInteractionEnabled = false
        }else {
            self.collectnViewOfFavMenus.backgroundColor = UIColor.clear
            cell.isUserInteractionEnabled = true
        }
        
        if currentDic["icon"] as? String != nil{
            let imgUrl = currentDic["icon"] as? String
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
            cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
            
            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                cell.imgOfMenu.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
            }else{
                if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                    Alamofire.request(imgUrl!).responseImage{ response in
                        if let image = response.result.value {
                            cell.imgOfMenu.image = image
                            self.chache.setObject(image, forKey: imageName as AnyObject)
                        }
                        else {
                            cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }else {
                    cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: nil)
        }
        delegate?.getSelectItem(SelecteItem: (self.appDelegate.arryFavMenuData[indexPath.row] as? [String:Any])!)
    }
}

//MARK:- WS Get logOut
extension FavouriteMenus {
   
    func callWSlogOut(){
        
        //URL : https://cmspreview.membrandt.com/api/logout?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "logout?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOflogOut(strURL: strURL, dictionary: dictionary )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOflogOut(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                userInfo.userPrivateKey = ""
                UserDefaults.standard.set("", forKey: "private_key")
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async {
                    self.delegate?.logOutBtnPress()
                }
            }
            else{
                self.delegate?.logOutBtnPress()
            }
        }, failure: { (error) in
            self.delegate?.logOutBtnPress()
        })
    }
    
}
