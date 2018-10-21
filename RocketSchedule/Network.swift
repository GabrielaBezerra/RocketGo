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

func getLocationIds(name: String, callback: @escaping ([Int]) -> Void) {
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

struct GetLaunchesQuery {
    let locationId: Int?
    let name: String?
    let startDate: Date?
    let endDate: Date?

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

    let json: JSON
}

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

func getLaunches(query: GetLaunchesQuery, callback: @escaping ([Launche]) -> ()) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"

    Alamofire.request(
        "https://launchlibrary.net/1.4/launch",
        parameters: query.toParameters()
    ).responseJSON { dataResponse in
        let data = try! JSON(data: dataResponse.data!)

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

                json: json
            )
        }

        callback(launches)
    }
}

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
