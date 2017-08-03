//
//  LNAddContactVC.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/29.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNAddContactVC: UIViewController {
    
    // MARK:- Public
    public var refreshBlock: (() -> Void)?
    
    public func set(contact: CNContact?) {
        tableView.set(contact: contact)
    }

    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addObserver()
    }
    
    // MARK:- Private func
    private func initUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.setBackgroundAlpha(alpha: 0)
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", image: nil, style: .plain, click: { [weak self] (item) in
            if let weakSelf = self {
                weakSelf.backToLastPage()
            }
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", image: nil, style: .plain, click: { [weak self] (item) in
            if let weakSelf = self {
                if weakSelf.tableView.contact != nil {
                    if ManContactManager.manager.updateContact(contact: weakSelf.tableView.mutaContact!) {
                        if weakSelf.refreshBlock != nil {
                            weakSelf.refreshBlock!()
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLNContactOperationCompletion), object: nil)
                        weakSelf.backToLastPage()
                    }
                } else {
                    if ManContactManager.manager.addContact(contact: weakSelf.tableView.mutaContact!) {
                        if weakSelf.refreshBlock != nil {
                            weakSelf.refreshBlock!()
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLNContactOperationCompletion), object: nil)
                        weakSelf.backToLastPage()
                    }
                }
            }
        })
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(tableView)
    }
    
    private func backToLastPage() {
        UIApplication.shared.keyWindow?.endEditing(true)
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.modalTransitionStyle = .crossDissolve
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func deleteContact() {
        if ManContactManager.manager.deleteContact(self.tableView.mutaContact!) {
            if self.refreshBlock != nil {
                self.refreshBlock!()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLNContactOperationCompletion), object: nil)
            self.backToLastPage()
        }
    }

    // MARK:- Private property
    fileprivate lazy var tableView: LNContactTableView = {
        let tableView = LNContactTableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.footView.deleteBtn.addTarget(self, action: #selector(deleteContact), for: .touchUpInside)
        return tableView
    }()
    

}

extension LNAddContactVC {
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            if let weakSelf = self {
                weakSelf.navigationItem.rightBarButtonItem?.isEnabled = weakSelf.isChanged()
            }
        }
    }
    
    fileprivate func isChanged() -> Bool {
        if tableView.contact == nil && (tableView.mutaContact?.isNull())! {
            return false
        } else if (tableView.contact != nil && (tableView.mutaContact?.isEqualTo(tableView.contact!))!) {
            return false
        }
        
        return true
    }
    
}

extension CNMutableContact {
    
    public func isNull() -> Bool {
        return !(self.familyName.characters.count > 0 || self.givenName.characters.count > 0 || self.organizationName.characters.count > 0 || self.phoneNumbers.count > 0 || self.emailAddresses.count > 0)
    }
    
    public func isEqualTo(_ contact: CNContact) -> Bool {
        return self.familyName == contact.familyName && self.givenName == contact.givenName && self.organizationName == contact.organizationName && self.phoneNumbers == contact.phoneNumbers && self.emailAddresses == contact.emailAddresses
    }
}

