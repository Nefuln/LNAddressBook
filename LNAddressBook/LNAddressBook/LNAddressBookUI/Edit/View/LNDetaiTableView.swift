//
//  LNDetaiTableView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/1.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNDetaiTableView: UITableView {
    
    // MARK:- Public property
    var contact: CNContact?
    var detailPhoneBlock: ((_ phone: String) -> Void)?
    var sendSmsBlock: (([[String : String]]) -> Void)?
    var scrollBlock: ((_ contentOffset: CGPoint) -> Void)?
    
    // MARK:- Public func
    public func reload(with contact: CNContact) {
        self.contact = contact
        self.reloadData()
    }

    // MARK:- Override
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private func
    private func initUI() {
        tableFooterView = UIView()
        separatorStyle = .none
        
        register(LNDetailPhoneCell.self, forCellReuseIdentifier: NSStringFromClass(LNDetailPhoneCell.self))
        register(LNDetailCommonCell.self, forCellReuseIdentifier: NSStringFromClass(LNDetailCommonCell.self))
        
        dataSource = self
        delegate = self
    }

}

extension LNDetaiTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contact?.mPhones == nil ? 1 : (self.contact?.mPhones!.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (self.contact?.mPhones?.count)! {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LNDetailPhoneCell.self), for: indexPath) as! LNDetailPhoneCell
            cell.titleLabel.text = self.contact?.mPhones?[indexPath.row].keys.first
            var phone = self.contact?.mPhones?[indexPath.row].values.first
            if !(phone?.contains("-"))! {
                phone?.insert("-", at: (phone?.index((phone?.startIndex)!, offsetBy: 3))!)
                phone?.insert("-", at: (phone?.index((phone?.startIndex)!, offsetBy: 7))!)
            }
            cell.phoneLabel.text = phone
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LNDetailCommonCell.self), for: indexPath) as! LNDetailCommonCell
        switch indexPath.row - (self.contact?.mPhones?.count)! {
        case 0:
            cell.titleLabel.text = "发送信息"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < (self.contact?.mPhones?.count)! && (detailPhoneBlock != nil) {
            detailPhoneBlock!((tableView.cellForRow(at: indexPath) as! LNDetailPhoneCell).phoneLabel.text!)
        }
        
        if indexPath.row - (self.contact?.mPhones?.count)! == 0 && sendSmsBlock != nil {
            sendSmsBlock!((self.contact?.mPhones)!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollBlock != nil {
            scrollBlock!(self.contentOffset)
        }
    }
}
