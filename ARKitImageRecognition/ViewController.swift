//
//  ViewController.swift
//  Image Recognition
//
//  Created by Jayven Nhan on 3/20/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import ARKit


class ViewController: UIViewController, MyProtocol {
    func pass(data: [String: Any]) {

        let newViewController =
                 self.storyboard?.instantiateViewController(withIdentifier: "HouseController") as! HouseController
        newViewController.myHouse = data
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    @IBOutlet weak var closeModal: UIImageView!
    @IBOutlet weak var innerModal: UIView!
    
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var questionButton: UIImageView!
    @IBOutlet weak var howModal: UIView!
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var QRButton: UIButton!
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    

    @IBAction func goQR(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
        ])
    }()
    
    lazy var treeNode: SCNNode = {
        guard let scene = SCNScene(named: "tree.scn"),
            let node = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.005
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x = -.pi / 2
        return node
    }()
    
    lazy var bookNode: SCNNode = {
        guard let scene = SCNScene(named: "book.scn"),
            let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var mountainNode: SCNNode = {
        guard let scene = SCNScene(named: "mountain.scn"),
            let node = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.25
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    @IBAction func goToQR(_ sender: Any) {
//        let newViewController =
//            QRViewController()
//        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func tapPrivacy() {
        guard let url = URL(string: "https://thaicolorid.com/PrivacyPolicy/PrivacyPolicy.pdf" as! String) else {
            return //be safe
        }; UIApplication.shared.openURL(url);
        
    }
    
    @objc func tapQuestion() {

        howModal.isHidden = false
    }
    
    @objc func tapCloseModal() {
        howModal.isHidden = true;
        sceneView.isHidden = false;
        let alertController = UIAlertController(title: "Important !", message: "Colorid need camera permission to show Augmented Reality video. Augmented Reality Technology need", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                //                if response {
                //                    //access granted
                //
                //                } else {
                //
                //                }
            }
        }
        
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func goToSetting(_ sender: Any) {
        goSetting()
    }
    
    func goSetting() {
        let alertController = UIAlertController (title: "To access camera", message: "Please go to setting to turn on permiss", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        howModal.isHidden = false;
        
        let tapPrivacy = UITapGestureRecognizer(target: self, action: #selector(self.tapPrivacy))
        privacyLabel.isUserInteractionEnabled = true
        privacyLabel.addGestureRecognizer(tapPrivacy)
        let tapCloseModal = UITapGestureRecognizer(target: self, action: #selector(self.tapCloseModal))
        closeModal.isUserInteractionEnabled = true
        closeModal.addGestureRecognizer(tapCloseModal)
        
        let tapQuestion = UITapGestureRecognizer(target: self, action: #selector(self.tapQuestion))
        questionButton.isUserInteractionEnabled = true
        questionButton.addGestureRecognizer(tapQuestion)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont(name: "Prompt-Medium", size: 18)!]
        
        sceneView.delegate = self
        setupScene()
        configureLighting()
        
        innerModal.layer.cornerRadius = 30
        menuButton.layer.cornerRadius =  30
        QRButton.layer.cornerRadius =  30

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConfiguration()
        resetTrackingConfiguration()
    }
    
    func setupScene() {
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "noname"

        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        if let videoURL = URL(string: "https://thaicolorid.com/vdoar/" + imageName[...1] + "/" + imageName[2...] + ".mp4"){
            
            setupVideoOnNode(planeNode, fromURL: videoURL)
        }
//        planeNode.runAction(imageHighlightAction)

        node.addChildNode(planeNode)
    }
    
    func setupVideoOnNode(_ node: SCNNode, fromURL url: URL){
        
        //1. Create An SKVideoNode
        var videoPlayerNode: SKVideoNode!
        
        //2. Create An AVPlayer With Our Video URL
        let videoPlayer = AVPlayer(url: url)
        let nodes = ["node": node]
        NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, userInfo: nodes)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: node )

        
        //3. Intialize The Video Node With Our Video Player
        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        
        //4. Create A SpriteKitScene & Postion It
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayerNode)
        
        //6. Set The Nodes Geoemtry Diffuse Contenets To Our SpriteKit Scene
        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        
        //5. Play The Video
        videoPlayerNode.play()
        videoPlayer.volume = 0
    
    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        
        let plane = note.object as! SCNNode
        print(plane)
        plane.removeFromParentNode()
    }
    


}


extension String {
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}
