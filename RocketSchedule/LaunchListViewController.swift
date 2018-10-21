//
//  LaunchListViewController.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit
import WebKit

class LaunchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var launches: [Launche] = []
    var imgs: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToNetwork() {
           loadData()
            emptyStateLabel.isHidden = true
        } else {
            emptyStateLabel.isHidden = false
        }
        
        setGradientToView(view: self.view)
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        let launchNib = UINib(nibName: "LaunchTableViewCell", bundle: .main)
        tableView.register(launchNib, forCellReuseIdentifier: LaunchTableViewCell.identifier)
        
        //customView()
    }
    
    func loadData() {
        let query = GetLaunchesQuery(locationId: nil, name: nil, startDate: nil, endDate: nil)

        getLaunches(query: query) { (launches) in
            
            self.launches = launches
            
            for (i,l) in launches.enumerated() {
                if l.missionName == "null" {
                    self.launches[i].missionName = "Unknown"
                }
                if l.launcheName == "null" {
                    self.launches[i].launcheName = "Unknown"
                }
                if l.missionDescription == "null" {
                    self.launches[i].missionDescription = ""
                }
            }
            
            let _ = self.launches.popLast()
            self.tableView.reloadData()
            print(launches.count)
            for (index, l) in launches.enumerated() {
                DispatchQueue.main.async {
                    getImage(url: l.imageUrl, index: "\(index)", completion: { (img, index, svg, response) in
                        if let img = img {
                            self.imgs[index] = img
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    ///
    var wk: WKWebView! = nil
    var bg: UIView! = nil
    
    func customView() {
        let vieww = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 180, height: 80))
        vieww.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        vieww.layer.cornerRadius = 3
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: vieww.frame.width-20, height: vieww.frame.height/2))
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Mission Name Enourmous Giant Name | yes its big | real big | what the actual fuck"
        
        let bframe = CGRect(x: 0, y: label.frame.maxY, width: vieww.frame.width, height: vieww.frame.height/2)
        let button = UIButton(type: .system)
        button.frame = bframe
        button.isUserInteractionEnabled = true
        button.setTitle("Stream Video URL", for: .normal)
        
        button.addTarget(self, action: #selector(openWebView), for: .touchDown)
        
        vieww.addSubview(label)
        vieww.addSubview(button)
        view.addSubview(vieww)
    }
    
    @objc func openWebView() {
        wk = WKWebView(frame: self.view.frame.applying(CGAffineTransform.init(scaleX: -0.8, y: -0.8)))
        wk.layer.cornerRadius = 7
        wk.center = UIApplication.shared.keyWindow!.center
        wk.load(URLRequest(url: URL(string: "https://google.com")!))
        
        bg = UIView(frame: self.view.frame)
        bg.backgroundColor = .black
        bg.alpha = 0.2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(diswk))
        bg.addGestureRecognizer(tap)
        
        self.view.addSubview(bg)
        self.view.addSubview(wk)
    }
    
    @objc func diswk() {
        wk?.removeFromSuperview()
        bg?.removeFromSuperview()
    }
    //////
    
    func setGradientToView(view: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
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

extension LaunchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as! LaunchTableViewCell
        cell.dateLabel.text = launches[indexPath.row].isoDate.description(with: Locale(identifier: "en-us"))
        cell.titleLabel.text = launches[indexPath.row].missionName
        cell.descriptionLabel.text = launches[indexPath.row].locationName
        if let img = imgs["\(indexPath.row)"] {
            cell.imgView.image = img
        }
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
