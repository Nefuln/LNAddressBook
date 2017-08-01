//
//  LNDetailHeaderView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/31.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNDetailHeaderView: UIView {
    
    let messageBtn: LNTagButton = {
        let msgBtn = LNTagButton()
        msgBtn.btn.setBackgroundImage(UIImage(named: "message"), for: .normal)
        return msgBtn
    }()
    
    let phoneBtn: LNTagButton = {
        let phoneBtn = LNTagButton()
        phoneBtn.btn.setBackgroundImage(UIImage(named: "phone"), for: .normal)
        return phoneBtn
    }()
    
    let shipinBtn: LNTagButton = {
        let shipinBtn = LNTagButton()
        shipinBtn.btn.setBackgroundImage(UIImage(named: "shipin"), for: .normal)
        shipinBtn.btn.isEnabled = false
        shipinBtn.label.text = "视频"
        return shipinBtn
    }()
    
    let emailBtn: LNTagButton = {
        let emailBtn = LNTagButton()
        emailBtn.btn.setBackgroundImage(UIImage(named: "shipin"), for: .normal)
        emailBtn.btn.isEnabled = false
        emailBtn.label.text = "邮件"
        return emailBtn
    }()
    
    public func setData(contact: CNContact) {
        nameLabel.text = CNContactFormatter.string(from: contact, style: .fullName) ?? " "
        if let imgData = contact.thumbnailImageData {
            imgNameLabel.isHidden = true
            imgView.image = UIImage(data: imgData)
        } else {
            imgNameLabel.isHidden = false
            imgView.image = nil
            imgView.backgroundColor = UIColor.gray
            imgNameLabel.text = nameLabel.text
        }
        if let key = contact.mPhones?.first?.keys.first {
            switch key {
            case "phone":
                messageBtn.label.text = "手机"
                phoneBtn.label.text = "手机"
                
            default:
                messageBtn.label.text = "信息"
                phoneBtn.label.text = "呼叫"
                break
            }

        } else {
            messageBtn.label.text = "信息"
            phoneBtn.label.text = "呼叫"
        }
        remake()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    // MARK:- Private func 
    private func initUI() {
        backgroundColor = UIColor.white
        addSubViews()
    }
    
    private func addSubViews() {
        addSubview(nameLabel)
        imgView.addSubview(imgNameLabel)
        addSubview(imgView)
        addSubview(messageBtn)
        addSubview(phoneBtn)
        addSubview(shipinBtn)
        addSubview(emailBtn)
    }
    
    private func layout() {
        
        
        let btnWidth: CGFloat = 35.0
        let btnHeight: CGFloat  = 55.0
        let padding = (ScreenWidth - 60 - 4*btnWidth)/3
        
        imgNameLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(imgView)
        }
        
        messageBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.left.equalTo(self.snp.left).offset(30)
            make.width.equalTo((btnWidth))
            make.height.equalTo(btnHeight)
        }
        
        phoneBtn.snp.makeConstraints { (make) in
            make.top.bottom.size.equalTo(messageBtn)
            make.left.equalTo(messageBtn.snp.right).offset(padding)
        }
        
        shipinBtn.snp.makeConstraints { (make) in
            make.top.bottom.size.equalTo(messageBtn)
            make.left.equalTo(phoneBtn.snp.right).offset(padding)
        }
        
        emailBtn.snp.makeConstraints { (make) in
            make.top.bottom.size.equalTo(messageBtn)
            make.left.equalTo(shipinBtn.snp.right).offset(padding)
        }
        
        remake()
    }
    
    func remake() {
        
        imgView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.nameLabel.snp.top).offset(-10)
            make.width.height.equalTo(80 - (275 - self.frame.size.height) * 0.4)
            imgView.layer.cornerRadius = (80 - (275 - self.frame.size.height) * 0.4) * 0.5
            imgView.layer.masksToBounds = true
        }
        
        nameLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(messageBtn.snp.top).offset(-10)
            make.size.equalTo((self.nameLabel.text?.ln_size(font: self.nameLabel.font, constrailnedToWidth: CGFloat.greatestFiniteMagnitude))!)
        }
    }

    
    // MARK:- Private property
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = UIColor.yellow
        imgView.layer.cornerRadius = 40
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.text = " "
        return nameLabel
    }()
    
    private let imgNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()
}

class LNTagButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.layer.cornerRadius = btn.frame.size.height * 0.5
        btn.layer.masksToBounds = true
    }
    
    // MARK:- Private func
    private func initUI() {
        addSubview(btn)
        addSubview(label)
    }
    
    private func layout() {
        btn.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(self.btn.snp.width)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            let height = label.text?.ln_height(font: label.font, constrailnedToWidth: CGFloat.greatestFiniteMagnitude)
            make.height.equalTo(height!)
        }
    }
    
    // MARK:- Public Property
    let btn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
}
