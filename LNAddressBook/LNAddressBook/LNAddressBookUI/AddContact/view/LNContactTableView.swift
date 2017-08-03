//
//  LNContactTableView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNContactTableView: UITableView {
    
    var phoneArr = [(tag: String, phone: String)]()
    var emailArr = [(tag: String, eamil: String)]()
    
    var contact: CNContact?
    var mutaContact: CNMutableContact? {
        get {
            if _mutaContact == nil {
                _mutaContact = CNMutableContact()
            }
            
            _mutaContact?.familyName = headerView.familyName
            _mutaContact?.givenName = headerView.givenName
            _mutaContact?.organizationName = headerView.companyName
            
            getPhones()
            getEmails()
            
            return _mutaContact
        }
    }
    
    public func set(contact: CNContact?) {
        self.contact = contact
        _mutaContact = contact?.mutableCopy() as? CNMutableContact
        
        headerView.set(contact: contact)
        tableFooterView = self.contact == nil ? UIView() : footView
        
        self.phoneArr.removeAll()
        self.emailArr.removeAll()

        for dict in (contact?.mPhones)! {
            self.phoneArr.append(("手机", dict.values.first!))
        }
        
        for dict in (contact?.mEmails)! {
            self.emailArr.append(("邮件", dict.values.first!))
        }
        
        reloadData()
    }
    
    public lazy var headerView: LNContactHeaderView = {
        let headerView = LNContactHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 150))
        return headerView
    }()
    
    public var footView: LNContactFootView = {
        let footView = LNContactFootView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 150))
        return footView
    }()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private func
    private func initUI() {
        tableFooterView = self.contact == nil ? UIView() : footView
        tableHeaderView = headerView
        separatorStyle = .none
        
        register(LNContactCell.self, forCellReuseIdentifier: NSStringFromClass(LNContactCell.self))
        dataSource = self
        delegate = self
    }
    
    fileprivate var _mutaContact: CNMutableContact?
    
}

extension LNContactTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LNContactCell.self), for: indexPath) as! LNContactCell
        switch indexPath.section {
        case 0:
            cell.tLabel.text = "添加电话"
        case 1:
            cell.tLabel.text = "添加电子邮件"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return (self.phoneArr.count == 0 || self.phoneArr.count == 1) ? 60 : CGFloat((self.phoneArr.count - 1) * 40 + 60)
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.tag = 1000 * (section + 1)

        switch section {
        case 0:
            for (idx, obj) in self.phoneArr.enumerated() {
                let subview = LNContactCommonAddView()
                subview.set(tagTitle: "\(obj.0)", placeholder: "", text: obj.phone)
                subview.editBlock = { (view) in
                    view.isEditing(true)
                }
                
                subview.deleteBlock = { [weak self] (view) in
                    if let weakSelf = self {
                        
                    }
                }
                view.addSubview(subview)
                subview.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(view)
                    make.bottom.equalTo(-idx*40)
                    make.height.equalTo(40)
                })
            }
        case 1:
            for (idx, obj) in self.emailArr.enumerated() {
                let subview = LNContactCommonAddView()
                subview.set(tagTitle: "\(obj.0)", placeholder: "", text: obj.eamil)
                subview.editBlock = { (view) in
                    view.isEditing(true)
                }
                
                subview.deleteBlock = { [weak self] (view) in
                    if let weakSelf = self {
                        
                    }
                }
                view.addSubview(subview)
                subview.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(view)
                    make.bottom.equalTo(-idx*40)
                    make.height.equalTo(40)
                })
            }

        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            self.getPhones()
            self.phoneArr.append(("手机", ""))
        case 1:
            getEmails()
            self.emailArr.append(("邮件", ""))
        default:
            break
        }
        tableView.reloadSections(IndexSet(indexPath), with: .automatic)
    }
}

extension LNContactTableView {
    fileprivate func getPhones() {
        let headerView = self.viewWithTag(1000)
        _mutaContact?.phoneNumbers.removeAll()
        self.phoneArr.removeAll()
        if headerView?.subviews.count == 0 {
            return
        }
        
        for subview in (headerView?.subviews)! {
            self.phoneArr.append((tag: "手机", phone: (subview as! LNContactCommonAddView).inputText ?? ""))
            let phone = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: (subview as! LNContactCommonAddView).inputText ?? ""))
            _mutaContact?.phoneNumbers.append(phone)
        }
    }
    
    fileprivate func getEmails() {
        let headerView = self.viewWithTag(2000)
        _mutaContact?.emailAddresses.removeAll()
        self.emailArr.removeAll()
        if headerView?.subviews.count == 0 {
            return
        }
        
        for subview in (headerView?.subviews)! {
            self.emailArr.append((tag: "邮件", phone: (subview as! LNContactCommonAddView).inputText ?? "") as! (tag: String, eamil: String))
            let email = CNLabeledValue(label: CNLabelHome, value: ((subview as! LNContactCommonAddView).inputText ?? "") as NSString)
            _mutaContact?.emailAddresses.append(email)
        }
    }
}
