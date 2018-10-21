//
//  SatelliteListViewController.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 21/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class SatelliteListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var satellites: [String] = ["International Space Station"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientToView(view: self.view)
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        let launchNib = UINib(nibName: "LaunchTableViewCell", bundle: .main)
        tableView.register(launchNib, forCellReuseIdentifier: LaunchTableViewCell.identifier)
    }
    
    func setGradientToView(view: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        //gradient.colors = [UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.8).cgColor, UIColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 0.8).cgColor]
        gradient.colors = [
            UIColor(red: 0.6, green: 0.3, blue: 0.5, alpha: 0.8).cgColor,
            UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.8).cgColor]
        //gradient.colors = [UIColor(red: 1, green: 140/255, blue: 0, alpha: 0.8).cgColor, UIColor(red: 1, green: 165/255, blue: 0, alpha: 0.8).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.backgroundColor = .clear
            
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        }
    }
    
}

extension SatelliteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return satellites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as! LaunchTableViewCell
        cell.dateLabel.text = Date().description(with: Locale(identifier: "en-us"))
        cell.titleLabel.text = satellites[indexPath.row]
        cell.descriptionLabel.text = "The International Space Station is a space station, or a habitable artificial satellite, in low Earth orbit. Its first component launched into orbit in 1998, and the last pressurised module was fitted in 2011. The station is expected to operate until at least 2028."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "satelliteSegue", sender: nil)
    }
    
}
