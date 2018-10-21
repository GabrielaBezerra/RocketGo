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

    var latitude: Double!
    var longitude: Double! {
        didSet {
            let cord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let viewRegion = MKCoordinateRegion(center: cord, latitudinalMeters: 3000000, longitudinalMeters: 3000000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = cord
            mapView.addAnnotation(annotation)
            mapView.setRegion(viewRegion, animated: false)
            mapView.mapType = .mutedStandard
            mapView.setCenter(cord, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
