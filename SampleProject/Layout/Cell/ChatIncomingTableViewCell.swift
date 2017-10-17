//
//  ChatIncomingTableViewCell.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/15.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit

class ChatIncomingTableViewCell: UITableViewCell {

    @IBOutlet weak var messageFrame: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
