//
//  LNAddressBookVC.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/29.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNAddressBookVC: UIViewController {
    
    // MARK:- Public Property
    lazy var tableView: LNAddressBookTableView = {
        let tableView = LNAddressBookTableView(frame: CGRect(x: 0, y: 40, width: ScreenWidth, height: ScreenHeight - 104), style: .plain)
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self.resultVC)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true

        searchController.searchBar.placeholder = "搜索"
        return searchController
    }()
    
    lazy var resultVC: LNAddressBookSearchVC = {
        let resultVC = LNAddressBookSearchVC()
        return resultVC
    }()
    
    var allContacts: [CNContact]? {
        get {
            return _allContacts
        }
    }
    
    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getAllContacts()
    }
    
    // MARK:- Private func 
    /**
     * 初始化UI
     */
    private func initUI() {
        self.navigationItem.title = "通讯录"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, click: {[weak self] (item) in
            if let weakSelf = self {
                weakSelf.addContact()
            }
        })
        
        addSubviews()
        
        definesPresentationContext = true
    }
    
    /**
     * 添加subviews
     */
    private func addSubviews() {
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 40)
        view.addSubview(searchController.searchBar)
        view.addSubview(tableView)
    }
    
    /**
     * 添加联系人
     */
    private func addContact() {
        let addContactVC = LNAddContactVC()
        let navi = UINavigationController(rootViewController: addContactVC)
        present(navi, animated: true, completion: nil)
    }
    
    /**
     * 异步获取所有联系人
     */
    private func getAllContacts() {
        ManContactManager.manager.getAllContactsByOrder {[weak self] (access, data) in
            if access == false {
                print("没有权限")
                return
            }
            
            if let weakSelf = self {
                //回到主线程更新UI
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadWithData(data?.0, indexs: data?.1)
                }
                weakSelf.resetAllContacts(data: data)
            }
        
        }
    }
    
    private func resetAllContacts(data: ([String: [CNContact]], [String])?) {
        _allContacts.removeAll()
        guard data != nil else {
            return
        }
        
        for key in (data?.1)! {
            let arr: [CNContact] = (data?.0[key])!
            _allContacts.append(contentsOf: arr)
        }
    }
    
    // MARK:- Private Property
    private var _allContacts = [CNContact]()
}

extension LNAddressBookVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        query(str: searchController.searchBar.text!) { [weak self] (contacts) -> Void? in
            //回到主线程更新UI
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.resultVC.reloadWithData(data: contacts)
                }
            }
        }
    }
    
    private func query(str: String, result: @escaping ([CNContact]?) -> Void? ) {
        
        if allContacts == nil {
            result(nil)
            return
        }
        
        var results = [CNContact]()
        //异步去查找数据
        DispatchQueue.global().async {[weak self] in
            
            if let weakSelf = self {
                for contact in weakSelf.allContacts! {
                    let fullName = CNContactFormatter.string(from: contact, style: .fullName)
                    if (fullName?.replacingOccurrences(of: " ", with: "").uppercased().contains(str.uppercased()))! {
                        results.append(contact)
                    } else {
                        if (fullName?.pinyinStr().replacingOccurrences(of: " ", with: "").uppercased().contains(str.uppercased()))! {
                            let newStr = fullName?.pinyinStr().uppercased()
                            let pinyinArr = newStr?.components(separatedBy: " ")
                            if weakSelf.isMatch(arr: pinyinArr!, str: str.uppercased(), fromIndex: 0) {
                                results.append(contact)
                            }
                        }
                    }
                }
                
                result(results)
            }
        }
    }
    
    private func isMatch(arr: [String], str: String, fromIndex: Int) -> Bool {
        
        for i in fromIndex ..< arr.count {
            let item = arr[i]
            if item.hasPrefix(str) {
                return true
            }
            
            if str.hasPrefix(item) {
                if i + 1 >= arr.count {
                    return false
                }
                
                return isMatch(arr: arr, str: str.replacingOccurrences(of: str, with: ""), fromIndex: i + 1)
            }
        }
        
        return false
    }
    
    
}
