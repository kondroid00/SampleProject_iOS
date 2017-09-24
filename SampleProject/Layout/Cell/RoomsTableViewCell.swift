//
//  RoomsTableViewCell.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/16.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift

class RoomsTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
    func setData(_ data: RoomDto?) {
        guard let data = data else {
            return
        }
        
        nameLabel.text = data.name
        themeLabel.text = data.theme
    }
    
}
