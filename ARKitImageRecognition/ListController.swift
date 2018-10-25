//
//  ListController.swift
//  ARKitImageRecognition
//
//  Created by Max on 25/10/2561 BE.
//  Copyright © 2561 Jayven Nhan. All rights reserved.
//

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    let houseList = ["max", "za"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        houseList.append("5555")
//        self.tblView.beginUpdates()
//        self.tblView.insertRows(at: [IndexPath.init(row: self.houseList.count-1, section: 0)], with: .automatic)
//        self.tblView.endUpdates()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = houseList[indexPath.row]
        
        return cell
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


