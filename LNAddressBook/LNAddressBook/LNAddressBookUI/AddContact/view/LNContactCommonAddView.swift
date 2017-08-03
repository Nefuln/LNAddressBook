//
//  LNContactCommonAddView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/3.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNContactCommonAddView: UIView {
    
    public var editBlock: ((_ addView: LNContactCommonAddView) -> Void)?
    public var deleteBlock: ((_ addView: LNContactCommonAddView) -> Void)?
    
    public var inputText: String? {
        get {
            return inputField.text
        }
    }
    
    // MARK:- Public
    public func set(tagTitle: String?, placeholder: String?, text: String? = "") {
        tagBtn.setTitle(tagTitle ?? "电话", for: .normal)
        inputField.placeholder = placeholder ?? "电话"
        inputField.text = text
    }
    
    public func isEditing(_ isEditing: Bool) {
        if _isEditing != isEditing {
            UIView.animate(withDuration: 1, animations: {
                if isEditing {
                    self.remakeForEditing()
                } else {
                    self.layout()
                }
            })
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
        addSubview(deleteBtn)
        addSubview(tagBtn)
        addSubview(inputField)
        addSubview(vLine)
        addSubview(hLine)
        addSubview(deleteConfirmBtn)
    }
    
    private func layout() {
        deleteBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(15)
        }
        
        tagBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.deleteBtn.snp.right).offset(10)
            make.top.bottom.equalTo(self)
            make.width.equalTo(60)
        }
        
        vLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.tagBtn.snp.right).offset(5)
            make.bottom.equalTo(self)
            make.top.equalTo(self.snp.top).offset(3)
            make.width.equalTo(0.5)
        }
        
        inputField.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.equalTo(self.deleteConfirmBtn.snp.left)
            make.left.equalTo(self.vLine.snp.right).offset(10)
        }
        
        hLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.deleteBtn)
            make.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        deleteConfirmBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(ScreenWidth)
            make.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
    }
    
    private func remakeForEditing() {
        deleteBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(-50)
            make.centerY.equalTo(self)
            make.width.height.equalTo(15)
        }
        
        tagBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.deleteBtn.snp.right).offset(10)
            make.top.bottom.equalTo(self)
            make.width.equalTo(60)
        }
        
        vLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.tagBtn.snp.right).offset(5)
            make.bottom.equalTo(self)
            make.top.equalTo(self.snp.top).offset(3)
            make.width.equalTo(0.5)
        }
        
        inputField.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.equalTo(self.deleteConfirmBtn.snp.left)
            make.left.equalTo(self.vLine.snp.right).offset(10)
        }
        
        hLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.deleteBtn)
            make.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        deleteConfirmBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(ScreenWidth - 100)
            make.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
    }
    
    private let deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.backgroundColor = UIColor.red
        deleteBtn.setImage(UIImage(named: ""), for: .normal)
        deleteBtn.addTarget(self, action: #selector(LNContactCommonAddView.onClickDeleteBtn), for: .touchUpInside)
        return deleteBtn
    }()
    
    private let tagBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.blue, for: .normal)
        return btn
    }()
    
    private let inputField: UITextField = {
        let field = UITextField()
        field.textColor = UIColor.black
        return field
    }()
    
    private let vLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    private let hLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()

    private let deleteConfirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(LNContactCommonAddView.onClickDeleteConfirmBtn), for: .touchUpInside)
        return btn
    }()
    
    private var _isEditing: Bool?
    
    // MARK:- Action
    @objc private func onClickDeleteBtn() {
        if editBlock != nil {
            editBlock!(self)
        }
    }
    
    @objc private func onClickDeleteConfirmBtn() {
        if deleteBlock != nil {
            deleteBlock!(self)
        }
    }
}
