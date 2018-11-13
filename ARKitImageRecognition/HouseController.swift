//
//  HouseController.swift
//  ARKitImageRecognition
//
//  Created by Max on 2/11/2561 BE.
//  Copyright © 2561 Jayven Nhan. All rights reserved.
//

import UIKit

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIImageView {
    public func maskCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
//        self.image = anyImage
    }
    public func maskCirclePercentage(percent: CGFloat, parent: UIView) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = percent * parent.frame.size.width / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        //        self.image = anyImage
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

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var houseColor: [String:Any] = [:]
}

class HouseController: UIViewController {
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var telBtn: UIView!
    
    @IBOutlet weak var badgeClose: UIImageView!
    @IBOutlet weak var modalClose: UIImageView!
    @IBOutlet weak var houseColorDetail: UILabel!
    
    @IBOutlet weak var houseColor: UIImageView!
    
    @IBOutlet weak var mapLogo: UIView!
    
    @IBOutlet weak var modalHouse: UILabel!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var mapLabel: UILabel!
    
    @IBOutlet weak var modalView: UIView!
    
    var myHouse:[String: Any] = [:]
    var imageList:[String] = [""]
    var houseVideo = ""
    var blurEffectView:UIVisualEffectView = UIVisualEffectView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
            afterLoadHouse()
    
        let tapGestureRecognizers = MyTapGesture(target: self, action: #selector(flagTapped))
        flagImage.isUserInteractionEnabled = true
        flagImage.addGestureRecognizer(tapGestureRecognizers)
       
        let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(mapTapped))
        mapLogo.isUserInteractionEnabled = true
        mapLogo.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizeer = MyTapGesture(target: self, action: #selector(tel))
        telBtn.isUserInteractionEnabled = true
        telBtn.addGestureRecognizer(tapGestureRecognizeer)
        // Do any additional setup after loading the view.
    }
    
    @objc func tel() {
        let telNum = myHouse["house_phone"] as! String
        UIApplication.shared.openURL(NSURL(string: "tel://"+telNum)! as URL)
    }
    
    @objc func flagTapped() {
        scrollView.addSubview(blurEffectView)
        scrollView.bringSubview(toFront: badgeView)
        badgeView.isHidden = false
    }
    
    @objc func mapTapped() {
        guard let url = URL(string: self.myHouse["house_address_url"] as! String) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

    
    func afterLoadHouse() {
        modalView.isHidden = true
        badgeView.isHidden = true
        
        self.mapLabel.text = self.myHouse["house_province"] as! String
        self.phoneLabel.text = self.myHouse["house_phone"] as! String
        self.nameLabel.text = self.myHouse["house_phone_home"] as! String
        
        
        self.modalView.layer.cornerRadius = 30
        self.badgeView.layer.cornerRadius = 30
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height:2300)
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        let galleryBtn = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        galleryBtn.image = #imageLiteral(resourceName: "gallery")
        galleryBtn.contentMode = UIViewContentMode.scaleAspectFit
        galleryBtn.layer.masksToBounds = true
        let tapGallery = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        galleryBtn.isUserInteractionEnabled = true
        galleryBtn.addGestureRecognizer(tapGallery)
        containView.addSubview(galleryBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containView)
        
        self.houseVideo = self.myHouse["house_video"] as! String
        
        self.houseNameLabel.text = self.myHouse["house_name"] as! String
        self.title = self.myHouse["house_name"] as! String
        let images = self.myHouse["house_image"] as! String
        
        self.imageList = images.toJSON() as! [String]
        self.profileImage.downloadImageFrom(link: imageList[0], contentMode: UIViewContentMode.scaleAspectFit)
        self.coverImage.downloadImageFrom(link: imageList[1], contentMode: UIViewContentMode.scaleAspectFit)
        let
        flag = self.myHouse["house_flag"] as! String
        if(flag == "A1") {
            self.flagImage?.image = #imageLiteral(resourceName: "a1")
        }
        else if(flag == "A2") {
            self.flagImage?.image = #imageLiteral(resourceName: "a2")
        }
        else if(flag == "B1") {
            self.flagImage?.image = #imageLiteral(resourceName: "b1")
        }
        else {
            self.flagImage?.image = #imageLiteral(resourceName: "b2")
        }
        
        let colors = self.myHouse["house_color"] as! String
        let colorList = colors.toJSON() as! [[String: Any]]
        
        
        var yColor: CGFloat = 0
        for color in colorList {
            let button = UIImageView(frame: CGRect(x: 35, y: yColor, width: self.view.frame.size.width-70, height: 30))
            button.backgroundColor = hexStringToUIColor(hex: color["color_code"] as! String)
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped))
            button.isUserInteractionEnabled = true
            button.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizer.houseColor = color
            
            self.colorView.addSubview(button)
            self.colorView.bringSubview(toFront: button)
            
            yColor += 38
        }
        
        
       
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        let detailTitle = UILabel(frame: CGRect(x: 0, y: yColor+15, width: self.view.frame.size.width, height: 22))
        detailTitle.font =  UIFont(name: "RuffleScriptDEMO-Regular", size: 26)
        detailTitle.text = "about house"
        detailTitle.textAlignment = .center
        
        self.colorView.addSubview(detailTitle)
        
        let detail = self.myHouse["house_detail"] as! String
        
        let detailLabel = UILabel(frame: CGRect(x: 35, y: yColor+50, width: self.view.frame.size.width-70, height: 0))
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        detailLabel.attributedText = detail.html2AttributedString
        detailLabel.sizeToFit()
        detailLabel.font = UIFont(name: detailLabel.font.fontName, size: 12)
        
        
        
        self.colorView.addSubview(detailLabel)
        
        let heightConstraint = NSLayoutConstraint(item: colorView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: yColor+70+detailLabel.frame.height)
        colorView.addConstraint(heightConstraint)
    
//    self.colorView.frame = CGRect(x: 0 , y: 0, width: self.contentView.frame.width, height: yColor+50+detailLabel.frame.height)
//    print(self.colorView.frame.height)
        
//        self.colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        
        self.profileImage.maskCirclePercentage(percent: 0.33, parent: self.view)
        
        self.modalHouse.text = self.myHouse["house_name"] as! String
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        modalClose.isUserInteractionEnabled = true
        modalClose.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(closeModall))
        badgeClose.isUserInteractionEnabled = true
        badgeClose.addGestureRecognizer(tapGestureRecognizerr)
        
     
        
        self.view.bringSubview(toFront: colorView)
        //        self.colorView.frame.size.height = self.view.frame.size.height - self.colorView.frame.origin.y
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc func addTapped() {
        
        let pushView = self.storyboard?.instantiateViewController(withIdentifier: "GalleryController") as! GalleryController
        pushView.houseGallery = self.imageList
        pushView.houseVideo = self.houseVideo
        self.navigationController?.pushViewController(pushView, animated: true)
        
    }
    
    @objc func closeModall() {
        badgeView.isHidden = true
        blurEffectView.removeFromSuperview()
        
    }
    
    @objc func closeModal() {
        modalView.isHidden = true
        blurEffectView.removeFromSuperview()
        
    }

    @objc func imageTapped(sender : MyTapGesture) {
        // your code goes here
        
        let colorTxt = sender.houseColor["color_text"] as! String
        houseColorDetail.attributedText = colorTxt.html2AttributedString
        houseColorDetail.numberOfLines = 0
        houseColorDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
        houseColorDetail.sizeToFit()
        
        houseColor.backgroundColor = hexStringToUIColor(hex: sender.houseColor["color_code"] as! String)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(blurEffectView)
        scrollView.bringSubview(toFront: modalView)
        modalView.isHidden = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
