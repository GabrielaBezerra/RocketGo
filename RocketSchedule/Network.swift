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
