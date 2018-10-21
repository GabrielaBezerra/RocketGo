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

/*
 EXEMPLO:
 getLaunches(
 query: GetLaunchesQuery(
 locationId: nil,
 name: nil,
 startDate: Date.from(year: 2018, month: 01, day: 01),
 endDate: Date.from(year: 2018, month: 06, day: 01)
 ),
 locationName: "japan"
 ) { launches in
 print(launches)
 }
 */

fileprivate func getLocationIds(name: String, callback: @escaping ([Int]) -> Void) {
    Alamofire
        .request("https://launchlibrary.net/1.4/location?name=\(name)")
        .responseJSON { dataResponse in
            let json = try! JSON(data: dataResponse.data!)
            
            let ids = json["locations"].map { (_, json) in
                json["id"].intValue
            }
            callback(ids)
    }
}

/// Cria a query de busca de lançamentos
struct GetLaunchesQuery {
    var locationId: Int? // Deixa como nil. Se quiser filtrar por localização, use a função getLaunches(query:locationName:callback)
    var name: String? // Nome do lançamento
    var startDate: Date? // Data de início
    let endDate: Date? // Data de fim
    func toParameters() -> Parameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var params: Parameters = [
            "mode": "verbose",
            "format": "json"
        ]
        
        if let startDate = startDate {
            params["startdate"] = formatter.string(from: startDate)
            
            if let endDate = endDate {
                params["enddate"] = formatter.string(from: endDate)
            }
        }
        
        if let name = name {
            params["name"] = name
        }
        
        if let locationId = locationId {
            params["locationId"] = locationId
        }
        
        return params
    }
}

/// Struct retornada pela busca de lançamento
struct Launche {
    let launcheName: String
    let missionName: String
    let missionDescription: String
    let isoDate: Date
    let latitude: Double
    let longitude: Double
    let locationName: String
    let countryCode: String
    let imageUrl: String
    let streamUrl: String
    
    let json: JSON
}

/// Struct com a posição do satelite
struct SatellitePosition {
    let name: String
    
    let latitudeA: Double
    let longitudeA: Double
    let altitudeA: Double
    
    let latitudeB: Double
    let longitudeB: Double
    let altitudeB: Double
    
    let json: JSON
}

/// Buscar lançamentos
func getLaunches(query: GetLaunchesQuery, callback: @escaping ([Launche]) -> ()) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
    
    Alamofire.request(
        "https://launchlibrary.net/1.4/launch",
        parameters: query.toParameters()
        ).responseJSON { dataResponse in
            let data = try! JSON(data: dataResponse.data!)
            print(data["launches"][0].description)
            //launch.json["agencies"]["infoURL"]
            let launches = data["launches"].map { (_, json) in
                return Launche(
                    launcheName: "\(json["name"])",
                    missionName: "\(json["missions"][0]["name"])",
                    missionDescription: "\(json["missions"][0]["description"])",
                    isoDate: dateFormatter.date(from: "\(json["isostart"])")!,
                    latitude: json["location"]["pads"][0]["latitude"].doubleValue,
                    longitude: json["location"]["pads"][0]["longitude"].doubleValue,
                    locationName: "\(json["location"]["name"])",
                    countryCode: "\(json["location"]["countryCode"])",
                    imageUrl: "\(json["rocket"]["imageURL"])",
                    streamUrl: "\(json["agencies"]["infoURL"][4])",
                    json: json
                )
            }
            
            callback(launches)
    }
}

/// Buscar lançamentos, filtrando por uma localização
func getLaunches(query: GetLaunchesQuery, locationName: String, callback: @escaping ([Launche]) -> ()) {
    getLocationIds(name: locationName) { ids in
        var callbackCount = 0
        
        ids.forEach { id in
            let queryWithLocationId = GetLaunchesQuery(
                locationId: id,
                name: query.name,
                startDate: query.startDate,
                endDate: query.endDate
            )
            
            var totalLaunches: [Launche] = []
            callbackCount += 1
            getLaunches(query: queryWithLocationId) { launches in
                totalLaunches += launches
                
                if callbackCount == ids.count {
                    callback(totalLaunches)
                }
            }
        }
    }
}

/// Buscar posição de um determinaod satélite. O *id* do satélite é definido de acordo com a N2YO, por exemplo, 25544 é da estação espacial internacional.
func getSatellitePosition(id satelliteId: Int, callback: @escaping (SatellitePosition) -> ()) {
    Alamofire.request(
        "https://www.n2yo.com/rest/v1/satellite/positions/\(satelliteId)/-3.71722/-38.54306/25/2&apiKey=47EHLN-28QXHF-LEG64C-3WHU"
        ).responseJSON { dataResponse in
            let data = try! JSON(data: dataResponse.data!)
            
            let satellitePosition = SatellitePosition(
                name: "\(data["info"]["satname"])",
                
                latitudeA: data["positions"][0]["satlatitude"].doubleValue,
                longitudeA: data["positions"][0]["satlongitude"].doubleValue,
                altitudeA: data["positions"][0]["sataltitude"].doubleValue,
                
                latitudeB: data["positions"][1]["satlatitude"].doubleValue,
                longitudeB: data["positions"][1]["satlongitude"].doubleValue,
                altitudeB: data["positions"][1]["sataltitude"].doubleValue,
                
                json: data
            )
            
            callback(satellitePosition)
    }
}


func getImage(url: String, index: String, completion: @escaping (UIImage?, String, String?, URLResponse) -> Void) {
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
                            completion(image, index, nil, res)
                        } else {
                            //get SVG response and send it through completion
                            if let svg = try? String(contentsOf: pictureURL) {
                                completion(nil, index, svg, res)
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
