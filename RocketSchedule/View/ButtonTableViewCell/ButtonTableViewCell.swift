//
//  ButtonTableViewCell.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    static var identifier: String = "ButtonTableViewCell"
    
    var launch: Launche!
    
//    var action: ()->Void = {
//        //performSegue
//    }
    @IBOutlet weak var button: UIButton!
    
    @IBAction func action(_ sender: UIButton) {
        //perform segue
        print("Button disgraçado")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 60
    }
    
}
