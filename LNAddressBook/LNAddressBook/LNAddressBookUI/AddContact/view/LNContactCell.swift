//
//  LNContactCell.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNContactCell: UITableViewCell {
    
    public let tLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
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
        addSubview(addImgView)
        addSubview(tLabel)
        addSubview(line)
    }
    
    private func layout() {
        addImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.height.equalTo(15)
        }
        
        tLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.addImgView)
            make.left.equalTo(self.addImgView.snp.right).offset(10)
            make.right.equalTo(self)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    private let addImgView: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleAspectFit
        imgview.backgroundColor = UIColor.green
        return imgview
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
}
