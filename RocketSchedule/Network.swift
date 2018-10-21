//
//  Network.swift
//  RocketSchedule
//
//  Created by Bruno Macabeus Aquino on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Launche {
    let launcheName: String
    let missionName: String
    let missionDescription: String
    let isoDate: Date
    let latitude: Double
    let longitude: Double
    let locationName: String
    let countryCode: String
    var imageUrl: String
    
    var image: UIImage
    
    let json: JSON
}

func getInfos(callback: @escaping (Launche) -> ()) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"

    Alamofire.request("https://launchlibrary.net/1.4/launch?next=1&mode=verbose&format=json").responseJSON { dataResponse in
        let data = try! JSON(data: dataResponse.data!)        
        let launcheJson = data["launches"][0]
        var img = UIImage()
        
        getImage(url: "\(launcheJson["rocket"]["imageURL"])") { (image, error, response) in
            if let image = image {
                DispatchQueue.main.async {
                    img = image
                }
            }
        }
        
        let launche = Launche(
            launcheName: "\(launcheJson["name"])",
            missionName: "\(launcheJson["missions"][0]["name"])",
            missionDescription: "\(launcheJson["missions"][0]["description"])",
            isoDate: dateFormatter.date(from: "\(launcheJson["isostart"])")!,
            latitude: launcheJson["location"]["pads"][0]["latitude"].doubleValue,
            longitude: launcheJson["location"]["pads"][0]["longitude"].doubleValue,
            locationName: "\(launcheJson["location"]["name"])",
            countryCode: "\(launcheJson["location"]["countryCode"])",
            imageUrl: "\(launcheJson["rocket"]["imageURL"])",
            image: img,
            
            json: launcheJson
        )

        callback(launche)
    }
}

func getImage(url: String, completion: @escaping (UIImage?, String?, URLResponse) -> Void) {
        
    if let pictureURL = URL(string: url) {
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    //print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            completion(image, nil, res)
                        } else {
                            //get SVG response and send it through completion
                            if let svg = try? String(contentsOf: pictureURL) {
                                completion(nil, svg, res)
                            }
                        }
                    } else {
                        print("Couldn't get image: ImageData is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    } else {
        print("Couldn't load image: malformed URL")
    }
}
