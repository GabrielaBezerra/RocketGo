//
//  LaunchDetailViewController.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class LaunchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var launch: Launche! 
    
    var titles: [String] = []
    var subtitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let imgnib = UINib(nibName: "MapTableViewCell", bundle: .main)
        tableView.register(imgnib, forCellReuseIdentifier: MapTableViewCell.identifier)
        
        let detailnib = UINib(nibName: "LaunchDetailTableViewCell", bundle: .main)
        tableView.register(detailnib, forCellReuseIdentifier: LaunchDetailTableViewCell.identifier)
        
        let btnnib = UINib(nibName: "ButtonTableViewCell", bundle: .main)
        tableView.register(btnnib, forCellReuseIdentifier: ButtonTableViewCell.identifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return UITableViewCell()
        }
        
        if indexPath.row == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchDetailTableViewCell.identifier) as! LaunchDetailTableViewCell
        cell.missionTitleLabel.text = launch.missionName
        cell.missionDateLabel.text = launch.isoDate.description(with: Locale(identifier: "en-us"))
        cell.locationLabel.text = launch.locationName
        cell.descriptionLabel.text = launch.missionDescription
        
        return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier) as! ButtonTableViewCell
        cell.launch = launch
        cell.action = {
            self.performSegue(withIdentifier: "mapModalSegue", sender: self.launch)
        }
        return cell
        
    }
    
}
