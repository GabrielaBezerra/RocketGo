//
//  Satellite.swift
//  RocketSchedule
//
//  Created by Marcus de Lima on 21/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import MapKit

class Satellite: NSObject, MKAnnotation{
    let title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    
    
    
    
    
}

