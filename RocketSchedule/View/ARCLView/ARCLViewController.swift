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

class ARCLViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.504571, longitude: -0.019717)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
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
