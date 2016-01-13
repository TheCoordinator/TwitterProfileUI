//
//  CustomTitleCell.swift
//  TwitterUI
//
//  Created by Peyman Khanjan on 13/01/2016.
//  Copyright © 2016 Snupps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomTitleCell: UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}