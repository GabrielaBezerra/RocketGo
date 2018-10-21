//
//  ImageTableViewCell.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 20/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    static var identifier: String = "ImageCellIdentifier"
    
    @IBOutlet weak var imageVw: UIImageView!
    
    var imgURL: String! {
        didSet {
//            getImage(url: imgURL) { (image, error, response) in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        self.imageVw.image = image
//                    }
//                }
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
