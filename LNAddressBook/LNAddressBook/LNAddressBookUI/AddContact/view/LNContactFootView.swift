//
//  LNContactFootView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNContactFootView: UIView {
    
    // MARK:- Public property
    public let deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("删除联系人", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 150)
        return btn
    }()
    
    // MARK:- Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Priavte func
    private func initUI() {
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(self.snp.left).offset(-0.5)
            make.right.equalTo(self.snp.right).offset(0.5)
            make.height.equalTo(40)
        }
    }

}
