//
//  MapTableViewCell.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 21/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    static var identifier: String = "MapTableViewCell"
    
    @IBOutlet weak var mapView: MKMapView!

    var latitude: String!
    var longitude: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cord = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        let viewRegion = MKCoordinateRegion(center: cord, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation = MKPointAnnotation()
        annotation.coordinate = cord
        mapView.addAnnotation(annotation)
        mapView.setRegion(viewRegion, animated: false)
        mapView.setCenter(cord, animated: true)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
