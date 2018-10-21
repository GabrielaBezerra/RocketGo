//
//  LaunchDetailTableViewCell.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class LaunchDetailTableViewCell: UITableViewCell {

    static var identifier: String = "LaunchDetailCellIdentifier"
    
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
