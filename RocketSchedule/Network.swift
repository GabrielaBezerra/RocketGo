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

func getInfos(callback: @escaping (Launche) -> ()) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"

    Alamofire.request("https://launchlibrary.net/1.4/launch?next=1&mode=verbose&format=json").responseJSON { dataResponse in
        let data = try! JSON(data: dataResponse.data!)

        let launcheJson = data["launches"][0]
        let launche = Launche(
            launcheName: "\(launcheJson["name"])",
            missionName: "\(launcheJson["missions"][0]["name"])",
            missionDescription: "\(launcheJson["missions"][0]["description"])",
            isoDate: dateFormatter.date(from: "\(launcheJson["isostart"])")!,
            latitude: launcheJson["location"]["pads"][0]["latitude"].doubleValue,
            longitude: launcheJson["location"]["pads"][0]["longitude"].doubleValue,
            locationName: "\(launcheJson["location"]["name"])",
            countryCode: "\(launcheJson["location"]["countryCode"])",

            json: launcheJson
        )

        callback(launche)
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
