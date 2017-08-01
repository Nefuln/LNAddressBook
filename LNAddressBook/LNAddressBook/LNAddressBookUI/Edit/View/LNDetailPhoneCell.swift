//
//  LNDetailCell.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/1.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNDetailPhoneCell: UITableViewCell {
    
    // MARK:- Public property
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = " "
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = " "
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private func
    private func initUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(line)
    }
    
    private func layout() {
        
        let padding = 5
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(20)
            make.top.equalTo(self.contentView.snp.top).offset(padding)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.height.equalTo((self.titleLabel.text?.ln_height(font: self.titleLabel.font, constrailnedToWidth: CGFloat.greatestFiniteMagnitude))!)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo((self.titleLabel))
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-padding)
            make.height.equalTo((self.phoneLabel.text?.ln_height(font: self.phoneLabel.font, constrailnedToWidth: CGFloat.greatestFiniteMagnitude))!)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.right.bottom.equalTo((self.contentView))
            make.height.equalTo(0.5)
        }
    }
    
    // MARK:- Private Property
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()

}
