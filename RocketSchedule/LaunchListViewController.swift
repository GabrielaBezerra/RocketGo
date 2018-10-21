//
//  LaunchListViewController.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class LaunchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var launches: [Launche] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfos { (lanche) in
            self.launches.append(lanche)
            self.launches.append(lanche)
            print(lanche.latitude)
            print(lanche.longitude)
            self.launches.append(lanche)
            self.launches.append(lanche)
            self.launches.append(lanche)
            self.launches.append(lanche)
            self.launches.append(lanche)
            self.tableView.reloadData()
        }
        
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
        
        gradient.colors = [UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.8).cgColor, UIColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 0.8).cgColor]
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

extension LaunchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as! LaunchTableViewCell
        cell.dateLabel.text = launches[indexPath.row].isoDate.description(with: Locale(identifier: "en-us"))
        cell.titleLabel.text = launches[indexPath.row].missionName
        cell.descriptionLabel.text = launches[indexPath.row].missionDescription
        //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "launchDetail", sender: launches[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? LaunchDetailViewController, let launch = sender as? Launche {
            destiny.launch = launch
            destiny.navigationController?.navigationBar.prefersLargeTitles = false
            destiny.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    
}
