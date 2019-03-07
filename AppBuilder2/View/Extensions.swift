//
//  ViewController_Extension.swift
//  MalaBes
//
//  Created by PUNDSK006 on 4/18/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import Foundation
import UIKit
protocol SortDelegate{
    func get(SelectedItem : String?)
}

extension UIApplication {
    
    var screenShot: UIImage?  {
        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
    
}
extension Collection where Iterator.Element == [String:String] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension UIViewController{
    
    func logoutVCCall() {
        //userInfo.userPrivateKey = ""
        //userInfo.userId = 0
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "private_Key")
        UserDefaults.standard.removeObject(forKey: "FromMyAccount")
        
        /*var isVCFound = false
         let viewControllers: [UIViewController] = self.navigationController!.viewControllers
         for aViewController in viewControllers {
         if aViewController is LoginViewController {
         isVCFound = true
         self.navigationController!.popToViewController(aViewController, animated: true)
         }
         }
         if isVCFound == false{
         self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!, animated: true)
         }*/
    }
    /*/ MARK:- UIActivityIndicatorView
    
    var activityIndicatorTag : Int {
        return 9999
    }
    var viewTag : Int {
        return 999
    }
    func startActivityIndicator(
        style: UIActivityIndicatorViewStyle? = nil,
        
        location: CGPoint? = nil) {
        let loc = location ?? self.view.center
        let styl = style ?? .whiteLarge
        
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: styl)
            let view1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            view1.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.2)
            
            //Add the tag so we can find the view in order to remove it later
            activityIndicator.tag = self.activityIndicatorTag
            view1.tag = self.viewTag
            
            //Set the location
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            activityIndicator.startAnimating()
            self.view.addSubview(view1)
            
            // self.view.addSubview(view1)
            // view1.addSubview(activityIndicator)
        }
    }
    //StopActivity
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            //            if let activityIndicator = self.view.subviews.filter(
            //                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
            //                activityIndicator.stopAnimating()
            //                activityIndicator.removeFromSuperview()
            //            }
            
            
            if let view =  self.view.subviews.filter(
                { $0.tag == self.viewTag }).first {
                //activityIndicator.stopAnimating()
                view.removeFromSuperview()
            }
        }
    }*/
    
    func createSettingsAlertController(title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"" ), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"" ), style: .default, handler: { action in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if #available(iOS 10, *){
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                }
                else{
                    _ = UIApplication.shared.openURL(url)
                }
            }
            //  UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        return controller
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //Add Shake animation and Remove Animation
    func addAnimation1(txtField: UITextField){
        txtField.background = nil
        txtField.layer.borderColor = color.shakeBorderColor.cgColor
        txtField.layer.borderWidth = 1.0
        txtField.shake()
    }
    
    func removeAnimation1(txtField: UITextField){
        txtField.layer.borderColor = nil
        txtField.layer.borderWidth = 0.0
        txtField.layer.borderColor = UIColor.clear.cgColor
        txtField.layer.borderWidth = 0.0
    }
    
    // MARK:- navigationController :- Set TintColor and Title
    
    func setNaviTitleWithBarTintColor(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color.navigationBar,  NSAttributedStringKey.font:UIFont(name: fontAndSize.NaviTitleFont1, size: fontAndSize.NaviTitleFontSize1)!]
        self.navigationController?.navigationBar.barTintColor = color.barTintColor
    }
    
    
    // MARK:- navigationController :- Set Back Button
    
    func setNaviBackButton()
    {
        
        //Design Of Navigation Bar Back_Button
        let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:20,height: 20))
        btnBack.setImage(UIImage(named:"back"), for: .normal)
        btnBack.addTarget(self,action: #selector(back), for: .touchUpInside)
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 20)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let backBarButtonitem = UIBarButtonItem(customView: btnBack)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
    }
    
    // MARK:- navigationController :- Set Cirlce Back With Title
    
    func NaviCircleBack(Title: String){
        self.navigationController?.navigationBar.barTintColor = color.barTintColor
        
        //GetWidth
        
        let width = Title.widthOfString(usingFont:UIFont(name: fontAndSize.NaviTitleFont, size: 17)!)
        
        
        // Set Back Button with image  and Add Action
        let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:30,height: 30))
        btnBack.setImage(UIImage(named:"backCircle"), for: .normal)
        btnBack.addTarget(self,action: #selector(back), for: .touchUpInside)
        
        
        //Set Title
        var  btntitle = UIButton()
        
        if width >= ScreenSize.SCREEN_WIDTH
        {
            btntitle = UIButton(frame: CGRect(x:0, y:0, width:100,height: 20))
        }
        else
        {
            btntitle = UIButton(frame: CGRect(x:0, y:0, width:width,height: 20))
        }
        
        
        btntitle.setTitle(Title, for: .normal)
        btntitle.setTitleColor(color.navigationBar, for: .normal)
        btntitle.titleLabel?.font = UIFont(name: fontAndSize.NaviTitleFont, size: 17)
        btntitle.titleLabel?.textAlignment = .left
        btntitle.addTarget(self,action: #selector(back), for: .touchUpInside)
        
        
        let menuBarButtonitem = UIBarButtonItem(customView: btnBack)
        let titleBarButtonitem = UIBarButtonItem(customView: btntitle)
        
        let arrLeftBarButtonItems : Array = [menuBarButtonitem,titleBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        
    }
    
    // MARK:- navigationController :- Set Design
    func navigationDesign(){
        setNaviTitleWithBarTintColor()
    }
    // MARK:- navigationController :- Set Back Action
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- default sharing
    func defaultShareTextWithImage(text:String) {
        // image and text to share
        let text = text
        
        // set up activity view controller
        let imageToShare = [text ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    @objc func btnYesClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnNoClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCloseClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func separateImageNameFromUrl(Url:String) -> String {
        let ownerImgUrl = Url
        let array = ownerImgUrl.components(separatedBy: "/")
        var imgName = ""
        if (array.count) > 0{
            imgName = (array.last)!
        }
        return imgName
    }
    
    func isValidDecimal(_ currText: String, _ range : NSRange, _ string: String) -> Bool {
        let replacementText = (currText as NSString).replacingCharacters(in: range, with: string)
        
        // Validate
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
    
    //MARK:- - NO Internate and No Data Found View
    
    func noInternatViewWithReturnView(imgeFlag:String, lableNoData:String, lableNoInternate: String)-> UIView{
        
        let screenSize: CGRect = UIScreen.main.bounds
        let noIntenateView = UIView(frame: CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height))
        noIntenateView.backgroundColor = UIColor.white
        // self.view.addSubview(noIntenateView)
        noIntenateView.isUserInteractionEnabled = false
        
        //Button
        let backButton = UIButton()
        backButton.frame = CGRect.init(x: 15, y: 40, width: 30, height: 30)
        backButton.setImage(UIImage(named:"backBalck"), for: .normal)
        backButton.addTarget(self,action: #selector(back), for: .touchUpInside)
        //backButton.tintColor = UIColor().HexToColor(hexString: delegate.backBtnColor!)
        
        var topOfbgView:CGFloat = 100
        var imageName = UIImage(named: "")
        if imgeFlag == "1" {
            imageName = UIImage(named: "noInternate")
        }
        else if imgeFlag == "0" {
            topOfbgView = 150
            imageName = UIImage(named: "white")
        }
        else if imgeFlag == "2" {
            imageName = UIImage(named: "sad_face")
        }
        else if imgeFlag == "3" {
            imageName = UIImage(named: "sad_face") // No Data/Somthing wents Wrong with Back Button
            noIntenateView.addSubview(backButton)
            noIntenateView.isUserInteractionEnabled = true
        }
        else if imgeFlag == "4" {
            imageName = UIImage(named: "noInternate") // No Intenate wents Wrong with Back Button
            noIntenateView.addSubview(backButton)
            noIntenateView.isUserInteractionEnabled = true
        }
        else if imgeFlag == "5"{
            topOfbgView = 150
        }
        else if imgeFlag == "6"{
            imageName = UIImage(named: "sad_face")
        }
        
        let bgView = UIView(frame: CGRect(x:0, y:(noIntenateView.frame.size.width/2.0) - 100, width: screenSize.width, height:220))
        bgView.backgroundColor = UIColor.clear
        bgView.isUserInteractionEnabled = false
        noIntenateView.addSubview(bgView)
        bgView.center = CGPoint.init(x: noIntenateView.frame.size.width  / 2, y: (noIntenateView.frame.size.height / 2) - topOfbgView)
        
        
        /*/Image
         let imageView = UIImageView(image: imageName!)
         imageView.frame = CGRect.init(x: 140, y: 0, width: noIntenateView.frame.size.width - 280, height: 100)
         bgView.addSubview(imageView)
         imageView.contentMode = UIViewContentMode.scaleAspectFit*/
        
        //label for no Data
        let lblNew = UILabel()
        lblNew.text = lableNoData
        lblNew.textColor = UIColor.darkGray
        lblNew.font = UIFont.systemFont(ofSize: 16)
        lblNew.frame = CGRect.init(x: 50, y: 100 , width: noIntenateView.frame.size.width - 100, height: 30)
        lblNew.textAlignment = .center
        bgView.addSubview(lblNew)
        
        //label no internet
        let lblNew1 = UILabel()
        lblNew1.text = lableNoInternate
        lblNew1.textColor = UIColor.black
        lblNew.font = UIFont.boldSystemFont(ofSize: 18)
        lblNew1.frame = CGRect.init(x: 30, y: lblNew.frame.origin.y + lblNew.frame.size.height + 10, width: noIntenateView.frame.size.width - 60, height: 80)
        lblNew1.numberOfLines = 0
        lblNew1.textAlignment = .center
        bgView.addSubview(lblNew1)
        return noIntenateView
    }
    
    
    func errorCodeAlert(title: String, description: String, errorCode: String , okButton: String){
        
        let alrtTitleStr = NSMutableAttributedString(string: title)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string:(description + "\n\(string.errodeCodeString) = [\(errorCode)]"))
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        let btnOk = UIAlertAction(title: okButton, style: .default, handler: { action in
            
        })
        
        alertController.addAction(btnOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension String{
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func isStringAnInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        return false
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat{
        _ = [NSAttributedStringKey.font: font]
        let size = self.size()
        return size.width
    }
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        return self.substring(from: range.upperBound)
    }
    
    var removeStartIndex : String {
        mutating get {
            self.remove(at: self.startIndex)
            return self
        }
    }
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }
    
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.characters.count <= maximumFractionDigits
        }
        
        return false
    }
    mutating func until(_ string: String) {
        var components = self.components(separatedBy: string)
        self = components[0]
    }
    mutating func nxtUntil(_ string: String) {
        var components = self.components(separatedBy: string)
        self = components[1]
    }
    
    func isValidDecimalWithNumber(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 9 ? numberComponents.first ?? "" : ""
            return fractionDigits.characters.count <= maximumFractionDigits
        }
        
        return false
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func getStartSting() -> Bool {
        
        if self.count > 8 {
            return true
        }
        return false
    }
}


extension NSMutableAttributedString{
    func widthOfString(usingFont font: UIFont) -> CGFloat{
        _ = [NSAttributedStringKey.font: font]
        let size = self.size()
        return size.width
    }
}

extension UIImageView{
    public func maskCircle(anyImage: UIImage){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
        
    }
}



extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension UIProgressView {
    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            //transform = CGAffineTransformMakeScale(1.0, heightScale)
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}

extension UIView{
    func shake(){
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [ 0, 10, -10, 10, 0 ]
        animation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 1.0 / 6.0), NSNumber(value: 3.0 / 6.0), NSNumber(value: 5.0 / 6.0), NSNumber(value: 1.0)]
        animation.duration = 0.4;
        animation.isAdditive = true
        
        layer.add(animation, forKey: "shake")
    }
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    // MARK:  BlurView
    func blurView() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurEffectView)
            
            //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = UIColor.black
        }
    }
    
}

extension Float{
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UIViewController {
    
    func checkForFontType(fontStyle:String,fontSize:CGFloat) -> UIFont {
        
        switch (fontStyle) {
            
        case "1":
            return UIFont(name: "SFCompactText-Regular", size: fontSize)!
            //UIFont(name: "Arial", size: fontSize)!
            
        case "2":
            return UIFont(name: "Raleway-Bold", size: fontSize)!
            
        case "3":
            return UIFont(name: "Raleway-SemiBold", size: fontSize)!
            
        case "4":
            return UIFont(name: "Raleway-BoldItalic", size: fontSize)!
            
        case "5":
            return UIFont(name: "Raleway-Medium", size: fontSize)!
            
        case "6":
            return UIFont(name: "Raleway-LightItalic", size: fontSize)!
            
        case "7":
            return UIFont(name: "Roboto-Regular", size: fontSize)!
            
        case "8":
            return UIFont(name: "Roboto-Bold", size: fontSize)!
            
        case "9":
            return UIFont(name: "Roboto-Medium", size: fontSize)!
            
        case "10":
            return UIFont(name: "Raleway-Regular", size: fontSize)!
            
        default:
            return UIFont(name: "Raleway-Regular", size: fontSize)!
            
        }
    }
    
    func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

public extension LazyMapCollection{
    func toArray() -> [Element]{
        return Array(self)
    }
}

extension UIColor {
    
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet.init(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}


extension UILabel {
   /* private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }*/
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let lines = Int(textSize.height/charSize)
        return lines
    }
}
// MARK:- TEXTFIELD
extension UITextField {
    
    func setBottomBorder(borderColor: UIColor) {
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = borderColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

// MARK:-
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
