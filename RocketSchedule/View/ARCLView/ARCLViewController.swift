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
import SceneKit

class ARCLViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()

    var annotationNode: LocationAnnotationNode! = nil
    var launch: Launche!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let coordinate = CLLocationCoordinate2D(latitude: launch.latitude, longitude: launch.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        //let image = UIImage(named: "pin")!
        
        let v = customView()
        var mm = imageWithView(view: v)!
        mm = mm.resize(size: CGSize(width: 280, height: 180))
        annotationNode = LocationAnnotationNode(location: location, image: mm)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismi))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
    }
    
    @objc func dismi() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func customView() -> UIView {
        let vieww = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 180, height: 110))
        vieww.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        vieww.layer.cornerRadius = 3
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: vieww.frame.width-20, height: vieww.frame.height/3))
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = launch.launcheName
        
        let slabel = UILabel(frame: CGRect(x: 10, y: label.frame.maxY, width: vieww.frame.width-20, height: vieww.frame.height/2))
        slabel.textColor = .gray
        slabel.adjustsFontSizeToFitWidth = true
        slabel.minimumScaleFactor = 0.7
        slabel.numberOfLines = 2
        slabel.textAlignment = .center
        slabel.text = launch.locationName
        
        vieww.addSubview(label)
        vieww.addSubview(slabel)

        return vieww
    }
    
}

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let height = (width/self.size.width)*self.size.height
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(height: CGFloat) -> UIImage {
        let width = (height/self.size.height)*self.size.width
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio  = size.width/self.size.width
        let heightRatio = size.height/self.size.height
        var updateSize = size
        if(widthRatio > heightRatio) {
            updateSize = CGSize(width:self.size.width*heightRatio, height:self.size.height*heightRatio)
        } else if heightRatio > widthRatio {
            updateSize = CGSize(width:self.size.width*widthRatio,  height:self.size.height*widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(updateSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: updateSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
