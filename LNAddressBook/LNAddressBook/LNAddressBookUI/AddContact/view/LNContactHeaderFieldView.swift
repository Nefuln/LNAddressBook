//
//  LNContactHeaderFieldView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNContactHeaderFieldView: UIView {
    
    public let textField: UITextField = {
        let field = UITextField()
        field.textColor = UIColor.black
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubview(textField)
        addSubview(line)
    }
    
    private func layout() {
        textField.snp.makeConstraints { (make) in
            make.top.right.equalTo(self)
            make.left.equalTo(self.snp.left).offset(10)
            make.bottom.equalTo(self.line.snp.top)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK:- Private property
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
}
