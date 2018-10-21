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
        
        gradient.colors = [UIColor(red: 0.5, green: 0.5, blue: 0.9, alpha: 0.8).cgColor, UIColor(red: 0.9, green: 0.8, blue: 1, alpha: 0.8).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as! LaunchTableViewCell
        cell.dateLabel.text = "12th December, 2018"
        cell.titleLabel.text = "Alcantara Launch"
        cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        return cell
    }
    
    
    
    
}
