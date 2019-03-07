//
//  AboutUs.swift
//  AppBuilder2
//
//  Created by Aditya on 27/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import WebKit

class AboutUs: UIViewController {

    var webViewLoading: WKWebView?
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var appDelegate : AppDelegate!
    var strLoadFlag = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackBtn()
        setNavigationBtn()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if strLoadFlag == "aboutUS"{
            let str = (appDelegate.ArryLngResponeCustom!["about_us"] as? String)!//"About Us"
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = (appDelegate.ArryLngResponeCustom!["about_us"] as? String)!//"About Us"
            }
        }else {
            let str = (appDelegate.ArryLngResponeCustom!["legal"] as? String)!//"Legal"
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = (appDelegate.ArryLngResponeCustom!["legal"] as? String)!//"Legal"
            }
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: checkForFontType(fontStyle: "1", fontSize: CGFloat(18))]
        
        self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: appDelegate.strStatusColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: appDelegate.strStatusColor)
        
        self.btnMenu.tintColor =  UIColor.white
        self.btnBack.tintColor =  UIColor.white
        
        webViewLoading?.uiDelegate = self
        webViewLoading?.navigationDelegate = self;
        webViewLoading?.scrollView.delegate = self;
        webViewLoading = WKWebView(frame: CGRect(x: 0, y:0, width: self.view.bounds.width, height:self.view.bounds.height))
        self.view.addSubview(webViewLoading!)
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if strLoadFlag == "aboutUS"{
            webViewLoading?.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Membrandt-About-us", ofType: "html")!)))
        }else {
            webViewLoading?.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Membrandt-Legal", ofType: "html")!)))
        }
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
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

//MARK:- WebView Delegate
extension AboutUs : WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewLoading?.frame.size.height = 1
        webViewLoading?.frame.size = webView.sizeThatFits(.zero)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webViewLoading?.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webViewLoading?.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                    
                })
            }
        })
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let newURL = navigationAction.request.url,
                let host = newURL.host , !host.hasPrefix("www.google.com") &&
                UIApplication.shared.canOpenURL(newURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(newURL, options: ["":""], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                print(newURL)
                //"Redirected to browser. No need to open it locally"
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.view.makeToast(string.someThingWrongMsg)
    }
    
    // Disable zooming in webView
    func viewForZooming(in: UIScrollView) -> UIView? {
        return nil;
    }
}

//MARK:- favMenuDelagte
extension AboutUs : favMenuDelagte {
    func homeBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
        else{
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
        }
        else{
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

