//
//  LNEditVC.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/31.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class LNDetailVC: UIViewController {
    
    // MARK:- Public Property
    var contact: CNContact?
    
    public lazy var tableView: LNDetaiTableView = {
        let tableView = LNDetaiTableView(frame: CGRect(), style: .plain)
        tableView.detailPhoneBlock = { [weak self] (phone) in
            if let weakSelf = self {
                weakSelf.detailWithPhone(phone: phone)
            }
        }
        
        tableView.sendSmsBlock = { [weak self] (phones) in
            if let weakSelf = self {
                weakSelf.onClickSendMsg()
            }
        }
        
        tableView.scrollBlock = { [weak self] (offset) in
            if let weakSelf = self {
                weakSelf.handleScroll(contentOffset: offset)
            }
        }
        return tableView
    }()

    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    // MARK:- Private func
    private func initUI() {
        navigationController?.navigationBar.setBackgroundAlpha(alpha: 0)
        view.backgroundColor = UIColor.gray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", image: nil, style: .plain, click: { [weak self] (item) in
            if let weakSelf = self {
                weakSelf.edit()
            }
        })
        
        addSubviews()
        layout()
        initData()
    }
    
    private func addSubviews() {
        view.addSubview(headerview)
        view.addSubview(tableView)
    }
    
    private func layout() {
        headerview.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(275)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo((self.view))
            make.top.equalTo(headerview.snp.bottom)
        }
    }
    
    private func initData() {
        if (self.contact != nil) {
            headerview.setData(contact: self.contact!)
            tableView.reload(with: self.contact!)
        }
    }
    
    private func edit() {
        let editVC = LNAddContactVC()
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // MARK:- Private Property
    fileprivate lazy var headerview: LNDetailHeaderView = {
        let headerview = LNDetailHeaderView()
        headerview.messageBtn.btn.addTarget(self, action: #selector(LNDetailVC.onClickSendMsg), for: .touchUpInside)
        headerview.phoneBtn.btn.addTarget(self, action: #selector(LNDetailVC.onClickPhone), for: .touchUpInside)
        return headerview
    }()

}

extension LNDetailVC {
    
    // MARK:- Action
    @objc func onClickSendMsg() {
        if self.contact?.mPhones?.count == 1 {
            sendMsg(phone: (self.contact?.mPhones?.first?.values.first)!)
        } else if ((self.contact?.mPhones?.count)! > 1) {
            let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for phone in (self.contact?.mPhones)! {
                var aPhone = phone.values.first
                if !(aPhone?.contains("-"))! {
                    aPhone?.insert("-", at: (aPhone?.index((aPhone?.startIndex)!, offsetBy: 3))!)
                    aPhone?.insert("-", at: (aPhone?.index((aPhone?.startIndex)!, offsetBy: 7))!)
                }

                let action = UIAlertAction(title: "\(phone.keys.first ?? "") \(aPhone ?? "")", style: .default, handler: { [weak self] (action) in
                    if let weakSelf = self {
                        weakSelf.sendMsg(phone: phone.values.first!)
                    }
                })
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func onClickPhone() {
        detailWithPhone(phone: (self.contact?.mPhones?.first?.values.first)!)
    }
    
    /**
     * 拨打电话
     */
    func detailWithPhone(phone: String) {
        let urlString = "tel://\(phone)"
        
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
    
    /**
     * 发送短信
     */
    func sendMsg(phone: String) {
        let urlString = "sms://\(phone)"
        
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension LNDetailVC {
    fileprivate func handleScroll(contentOffset: CGPoint) {
        print(contentOffset)
        let y = contentOffset.y

        var tmpFrame = self.headerview.frame
        
        if (self.headerview.frame.maxY >= 175 && y > 0) || (self.headerview.frame.maxY <= 275 && y < 0) {
            tmpFrame.size.height -= y
            
            if tmpFrame.size.height >= 275 {
                tmpFrame.size.height = 275
            } else if (tmpFrame.size.height <= 175) {
                tmpFrame.size.height = 175
            }
            
            self.headerview.snp.updateConstraints { (make) in
                make.left.top.right.equalTo(self.view)
                make.height.equalTo(tmpFrame.size.height)
            }
            
            self.headerview.remake()
        }
        
        self.headerview.frame = tmpFrame
    }
}
