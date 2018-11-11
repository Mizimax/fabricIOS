//
//  GalleryController.swift
//  ARKitImageRecognition
//
//  Created by Max on 6/11/2561 BE.
//  Copyright © 2561 Jayven Nhan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class GalleryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    
    var houseGallery = [""]
    var houseVideo = ""
    var blurEffectView:UIVisualEffectView = UIVisualEffectView()
    var image:UIImageView = UIImageView()
    var close:UIImageView = UIImageView()

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var videoGallery: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        // Do any additional setup after loading the view.
    }
    
    private func playVideo() {
        let videoURL = URL(string: self.houseVideo)
        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.videoGallery.addSubview(playerController.view)
        playerController.view.frame = self.videoGallery.frame
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: myCell.bounds.size.width, height: myCell.bounds.size.height))
        image.downloadImageFrom(link: self.houseGallery[indexPath.row], contentMode: UIViewContentMode.scaleToFill)
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleToFill
        myCell.contentView.addSubview(image)
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        image = UIImageView(frame: CGRect(x: 35, y: -100, width: view.bounds.size.width-70, height: view.bounds.size.height))
        
        image.downloadImageFrom(link: houseGallery[indexPath.row], contentMode: UIViewContentMode.scaleAspectFit)
        
        close = UIImageView(frame: CGRect(x: view.center.x-25, y: view.center.y+100, width: 50, height: 50))
        close.image = #imageLiteral(resourceName: "close")
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(singleTap)
        
       
        view.addSubview(blurEffectView)
        view.addSubview(image)
        view.addSubview(close)
        
        
    }
    //Action
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        image.removeFromSuperview()
        close.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        // Your action
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
