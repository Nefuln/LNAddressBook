//
//  LNContactHeaderView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNContactHeaderView: UIView {
    
    public func set(contact: CNContact?) {
        if contact == nil {
            return
        }
        
        let img: UIImage? = contact!.thumbnailImageData != nil ? UIImage(data: contact!.thumbnailImageData!) : nil
        if img != nil {
            addPhotoBtn.setBackgroundImage(img, for: .normal)
            addPhotoBtn.setTitle(nil, for: .normal)

        } else {
            addPhotoBtn.setTitle("添加\n照片", for: .normal)
        }
        
        self.familyNameView.textField.text = contact?.familyName
        self.givenNameView.textField.text = contact?.givenName
        self.companyView.textField.text = contact?.organizationName
    }
    
    // MARK:- Public property
    var addPhotoBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("添加\n照片", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        return btn
    }()
    
    public var familyName: String {
        get {
            return self.familyNameView.textField.text ?? ""
        }
    }
    
    public var givenName: String {
        get {
            return self.givenNameView.textField.text ?? ""
        }
    }
    
    public var companyName: String {
        get {
            return self.companyView.textField.text ?? ""
        }
    }
    
    // MARK:- Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private func
    private func initUI() {
        addSubview(addPhotoBtn)
        addSubview(editBtn)
        addSubview(familyNameView)
        addSubview(givenNameView)
        addSubview(companyView)

    }
    
    private func layout() {
        addPhotoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalTo(self.snp.left).offset(30)
            make.width.height.equalTo(50)
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.addPhotoBtn)
            make.top.equalTo(self.addPhotoBtn.snp.bottom).offset(5)
            make.size.greaterThanOrEqualTo(0)
        }
        
        familyNameView.snp.makeConstraints { (make) in
            make.left.equalTo(self.addPhotoBtn.snp.right).offset(20)
            make.right.equalTo(self)
            make.top.equalTo(self.snp.top).offset(5)
            make.height.equalTo(30)
        }
        
        givenNameView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.familyNameView)
            make.top.equalTo(self.familyNameView.snp.bottom).offset(5)
        }
        
        companyView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.familyNameView)
            make.top.equalTo(self.givenNameView.snp.bottom).offset(5)
        }
    }
    
    // MARK:- Private property
    private let editBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("编辑", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        return btn
    }()
    
    private let familyNameView: LNContactHeaderFieldView = {
        let view = LNContactHeaderFieldView()
        view.textField.placeholder = "姓氏"
        return view
    }()
    
    private let givenNameView: LNContactHeaderFieldView = {
        let view = LNContactHeaderFieldView()
        view.textField.placeholder = "名字"
        return view
    }()
    
    private let companyView: LNContactHeaderFieldView = {
        let view = LNContactHeaderFieldView()
        view.textField.placeholder = "公司"
        return view
    }()

}


