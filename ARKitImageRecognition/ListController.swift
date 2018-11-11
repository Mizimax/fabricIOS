//
//  ListController.swift
//  ARKitImageRecognition
//
//  Created by Max on 25/10/2561 BE.
//  Copyright © 2561 Jayven Nhan. All rights reserved.
//

import UIKit

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
    
}

extension UIImage {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var houseList: [[String: Any]] = []
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        parseJSON()
//        houseList.append("5555")
//        self.tblView.beginUpdates()
//        self.tblView.insertRows(at: [IndexPath.init(row: self.houseList.count-1, section: 0)], with: .automatic)
//        self.tblView.endUpdates()
        // Do any additional setup after loading the view.
    }
    
    func parseJSON () {
        
        let url = URL(string: "https://thaicolorid.com/api/v1/houses")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            
            
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
//            guard let jsonArray = json as? [[String: Any]] else {
//                return
//            }
//
//            print(jsonArray)
//
            if let array = json["data"] as? [[String: Any]] {

                self.houseList = array
            }
            
//            print(self.houseList)
           
            
            
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! tableViewController
        cell.houseText?.text = self.houseList[indexPath.row]["house_name"] as! String
        let images = self.houseList[indexPath.row]["house_image"] as! String
        
        let firstImage = images.toJSON() as! [String]
        
        cell.profileImage?.clipsToBounds = true
        cell.profileImage?.layer.cornerRadius =  17.5
        cell.profileImage?.downloadImageFrom(link: firstImage[0], contentMode: UIViewContentMode.scaleAspectFit)
        
        let flag = self.houseList[indexPath.row]["house_flag"] as! String
        if(flag == "A1") {
            cell.flagImage?.image = #imageLiteral(resourceName: "a1")
        }
        else if(flag == "A2") {
            cell.flagImage?.image = #imageLiteral(resourceName: "a2")
        }
        else if(flag == "B1") {
            cell.flagImage?.image = #imageLiteral(resourceName: "b1")
        }
        else {
            cell.flagImage?.image = #imageLiteral(resourceName: "b2")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let pushView = self.storyboard?.instantiateViewController(withIdentifier: "HouseController") as! HouseController
        pushView.myHouse = self.houseList[indexPath.row]
        self.navigationController?.pushViewController(pushView, animated: true)
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

class tableViewController : UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var houseText: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
}

struct House {
    var house_id: Int
    var house_name: String
    var house_detail: String
    var house_province: String
    var house_address_url: String
    var house_phone: String
    var house_phone_home: String
    var house_image: String
    var house_video: String
    var house_flag: String
    var house_color: String
}


