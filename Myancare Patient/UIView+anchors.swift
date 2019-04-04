//
//  UIView+anchors.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import AlamofireImage

extension UIViewController{
    func showAlert(title:String, message:String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let didReceiveDataForChatRoomList = Notification.Name("didReceiveDataForChatRoomList")
    static let didReceiveDataForChatRecord = Notification.Name("didReceiveDataForChatRecord")
    static let didReceiveDataForNewChatMessage = Notification.Name("didReceiveDataForNewChatMessage")
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension UIColor {
    //colors from Myancare UI
    struct MyanCareColor {
        static let green = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1) //green
        static let orange = UIColor(red:0.94, green:0.36, blue:0.19, alpha:1) //orange
        static let gray = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1) //gray
        static let blue = UIColor(red:0.07, green:0.42, blue:0.98, alpha:1) //blue
        static let curiousBlue = UIColor(red:0.14, green:0.61, blue:0.82, alpha:1)
        static let lightGray = UIColor(red:0.81, green:0.8, blue:0.8, alpha:1) //light gray
        static let fbBlue = UIColor(red:0.31, green:0.45, blue:0.65, alpha:1) //facebook blue
        static let yellow = UIColor(red:0.98, green:0.83, blue:0.19, alpha:1) //yellow
        static let darkGray = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1) //dark gray
        static let iconColor = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1) //icon color
        static let font1 = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1)
        static let font2 = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1)
        static let font3 = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1)
        static let lightSeaGreen = UIColor(red:0.11, green:0.69, blue:0.65, alpha:1) //green blue
        static let mantis = UIColor(red:0.53, green:0.76, blue:0.38, alpha:1) //green
        static let flamingo = UIColor(red:0.93, green:0.36, blue:0.19, alpha:1) //orange
    }
}

extension UIImage{
    class func loadImage(_ urlString:String, result: @escaping (UIImage) -> ()){
        if urlString != ""{
            let url = URL(string: "\(urlString.replacingOccurrences(of: " ", with: ""))")!
            Alamofire.request(url).responseImage { response in
                
                if let image = response.result.value {
                    result(image)
                } else {
                    result(UIImage(named: "no-image")!)
                }
            }
        } else {
            result(UIImage(named: "no-image")!)
        }
    }
}

extension UIFont {
    
    struct MyanCareFont {
        static let title = UIFont.mmFontBold(ofSize: 28)
        static let subtitle1 = UIFont.mmFontBold(ofSize: 20)
        static let subtitle2 = UIFont.mmFontBold(ofSize: 18)
        static let textBox = UIFont.mmFontRegular(ofSize: 14)
        static let button1 = UIFont.mmFontBold(ofSize: 14)
        static let button2 = UIFont.mmFontBold(ofSize: 20)
        static let chip = UIFont.mmFontBold(ofSize: 14)
        static let type1 = UIFont.mmFontBold(ofSize: 20)
        static let type2 = UIFont.mmFontBold(ofSize: 16)
        static let type3 = UIFont.mmFontRegular(ofSize: 14)
        static let type4 = UIFont.mmFontRegular(ofSize: 12)
        static let type5 = UIFont.mmFontRegular(ofSize: 10)
        static let type6 = UIFont.mmFontRegular(ofSize: 11)
        static let type7 = UIFont.mmFontBold(ofSize: 18)
        static let type8 = UIFont.mmFontRegular(ofSize: 13)
        static let type9 = UIFont.mmFontRegular(ofSize: 10)
        static let type10 = UIFont.mmFontRegular(ofSize: 25)
        static let type1unbold = UIFont.mmFontRegular(ofSize: 20)
        static let type2unbold = UIFont.mmFontRegular(ofSize: 16)
    }
    
    class func mmFontRegular(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pyidaungsu", size: fontSize)!
    }
    
    class func mmFontBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pyidaungsu-bold", size: fontSize)!
    }
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func calculateHeightofTextView(dummyText: String, fontSize: CGFloat, viewWdith: CGFloat) -> CGFloat {
        let estimateheight:CGFloat = CGFloat(dummyText.count)
        let approximateWithOfBioTextView = viewWdith
        let size = CGSize(width: approximateWithOfBioTextView, height: estimateheight)
        let attributes = [NSAttributedString.Key.font: UIFont.mmFontBold(ofSize: fontSize)]
        let estimatedFrame = NSString(string: dummyText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
    
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}

