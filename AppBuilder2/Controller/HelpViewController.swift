//
//  HelpViewController.swift
//  AppBuilder2
//
//  Created by Pavan Jadhav on 06/04/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableOfHelpVc: UITableView!
    
    var secHeaderArray = ["Quick Training Videos","FAQ","My Questions"]
    var sec1Array = ["App Navigation","Billing, Email Reset & Settings","Other", ""]
    var sec2Array = ["View All Questions", ""]
    var sec3Array = ["View My Questions", "Ask New Question"]
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSCoursData = Array<Any>()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var strMenuId = ""
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        self.chache = NSCache()
        
        self.title = "Help"
        setBackBtn()
        setNavigationBtn()
        
        getUIForHelp()
   }
    
    func setBackBtn() {
        //setNaviBackButton()
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        //        btnBack.alignmentRectInsets.left = -10
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
    
    @objc func backClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBtn() {
        let origImage = UIImage(named: "side-menu");
        btnMenu = UIButton(frame: CGRect(x: 0, y:0, width:25,height: 25))
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnMenu.setImage(tintedImage, for: .normal)
        btnMenu.addTarget(self,action: #selector(menu), for: .touchUpInside)
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let backBarButtonitem = UIBarButtonItem(customView: btnMenu)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.rightBarButtonItems = arrLeftBarButtonItems
        
    }
    
    @objc func menu(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteMenus") as! FavouriteMenus
        vc.delegate = self as? favMenuDelagte
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
        //        callWSOfSubscription()
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func cancelWeb() {
        print("cancelWeb")
        if apiSuccesFlag == "1"{
            //self.view.makeToast(string.someThingWrongMsg)
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getUIForHelp() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    let bgcolor = navigation_bar["bgcolor"]
                    let txtcolorHex = navigation_bar["txtcolorHex"]
                    let menu_icon_color = navigation_bar["menu_icon_color"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
//                    let genrltxtColor = general_font["txtcolorHex"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    self.view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor!)
                    self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                   
                    commonElement = common_element
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
}


// MARK:- TABLEVIEW DELEGATE DATASOURCE
extension HelpViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        return sec1Array.count
           
        }
       else if section == 1 {
            return sec2Array.count
        }
       else {
            return sec3Array.count
        }
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfRow", for: indexPath) as! TableViewCell
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        
        let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
        let medium = genrlFontSize["medium"]
        let mediumInt:Int = Int(medium!)!
        
        let general_font = genarlSettings["general_font"] as! [String:Any]
        let fontstyle = general_font["fontstyle"] as! String
        let genrltxtColor = general_font["txtcolorHex"] as! String
        let bgScreenColor = genarlSettings["screen_bg_color"] as! String
        
        cell.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
        
        cell.lblOfHelpVcCell.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt))
        cell.lblOfHelpVcCell.textColor = UIColor().HexToColor(hexString: genrltxtColor)
        
        if indexPath.section == 0 {
            cell.lblOfHelpVcCell.text = sec1Array[indexPath.row]
        }
        if indexPath.section == 1 {
            cell.lblOfHelpVcCell.text = sec2Array[indexPath.row]
        }
        if indexPath.section == 2 {
            cell.lblOfHelpVcCell.text = sec3Array[indexPath.row]
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                 cell.btnOfHelpVcCell.isHidden = true
                cell.imgOfRightArrow.isHidden = true
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                cell.btnOfHelpVcCell.isHidden = true
                cell.imgOfRightArrow.isHidden = true
            }
        }
         return cell
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfHeader") as! TableViewCell
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        
        let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
        let medium = genrlFontSize["medium"]
        let mediumInt:Int = Int(medium!)!
        
        let general_font = genarlSettings["general_font"] as! [String:Any]
        let fontstyle = general_font["fontstyle"] as! String
        let genrltxtColor = general_font["txtcolorHex"] as! String
        
        cell.lblOfHelpVcHeader.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt))
        cell.lblOfHelpVcHeader.textColor = UIColor().HexToColor(hexString: genrltxtColor)
        cell.lblOfHelpVcHeader.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt))
        
        cell.lblOfHelpVcHeader.text = secHeaderArray[section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK:- favMenuDelagte
extension HelpViewController : favMenuDelagte {
    func homeBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func logOutBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is Login {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    func getSelectItem(SelecteItem: [String:Any]) {
        if((SelecteItem["type"] as? String) != nil){
            if SelecteItem["type"] as? String == "M"{
                //call getHomemenuList API with ID ==> PDF page no 47 >>> call CoursesList
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoursesList") as! CoursesList
                vc.strMenuId = (SelecteItem["id"] as? String)!
                vc.strTitle = (SelecteItem["title"] as? String)!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if SelecteItem["type"] as? String == "T"{
                if((SelecteItem["itemType"] as? String) != nil){
                    if SelecteItem["itemType"] as? String == "1"{ //itemType == 1 for corses
                        if ((SelecteItem["template_type"] as? String) != nil){
                            if SelecteItem["template_type"] as? String == "D"{
                                //call getCoursetopiclisting API ==>PDF page no 49-51 >>> DetailViewController
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                                vc.strCourseId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if SelecteItem["template_type"] as? String == "F"{
                                //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
                                let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
                                nextVC.StrCourseCatgryId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                    }else if SelecteItem["itemType"] as? String == "2"{ //itemType == 2 for Blog
                        UserDefaults.standard.set("2", forKey: "paymentFlag")
                        UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                        vc.strMenuId = (SelecteItem["id"] as? String)!
                        vc.dicMediaData = (SelecteItem as? NSDictionary)!
                        vc.strTitle = (SelecteItem["title"] as? String)!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
}
