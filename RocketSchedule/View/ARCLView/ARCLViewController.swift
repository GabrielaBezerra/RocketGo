//
//  ARCLViewController.swift
//  RocketSchedule
//
//  Created by Marcus de Lima on 21/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import WebKit

class ARCLViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()
    
    var launch: Launche!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let coordinate = CLLocationCoordinate2D(latitude: launch.latitude, longitude: launch.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
        print(launch.streamUrl)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    

    var wk: WKWebView! = nil
    var bg: UIView! = nil
    
    func customView() {
        let vieww = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 180, height: 80))
        vieww.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        vieww.layer.cornerRadius = 3
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: vieww.frame.width-20, height: vieww.frame.height/2))
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Mission Name Enourmous Giant Name | yes its big | real big | what the actual fuck"
        
        let bframe = CGRect(x: 0, y: label.frame.maxY, width: vieww.frame.width, height: vieww.frame.height/2)
        let button = UIButton(type: .system)
        button.frame = bframe
        button.isUserInteractionEnabled = true
        button.setTitle("Stream Video URL", for: .normal)
        
        button.addTarget(self, action: #selector(openWebView), for: .touchDown)
        
        vieww.addSubview(label)
        vieww.addSubview(button)
        view.addSubview(vieww)
    }
    
    @objc func openWebView() {
        wk = WKWebView(frame: self.view.frame.applying(CGAffineTransform.init(scaleX: -0.8, y: -0.8)))
        wk.layer.cornerRadius = 7
        wk.center = UIApplication.shared.keyWindow!.center
        wk.load(URLRequest(url: URL(string: "https://google.com")!))
        
        bg = UIView(frame: self.view.frame)
        bg.backgroundColor = .black
        bg.alpha = 0.2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(diswk))
        bg.addGestureRecognizer(tap)
        
        self.view.addSubview(bg)
        self.view.addSubview(wk)
    }
    
    @objc func diswk() {
        wk?.removeFromSuperview()
        bg?.removeFromSuperview()
    }
}
