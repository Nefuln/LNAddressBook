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
        let tableView = LNAddressBookTableView(frame: CGRect(x: 0, y: 108, width: ScreenWidth, height: ScreenHeight - 104), style: .plain)
        tableView.cellDidSelectedBlock = {[weak self] (contact) in
            if let weakSelf = self {
                weakSelf.detailPage(contact)
            }
        }
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
        addObserver()
    }
    
    // MARK:- Private func 
    /**
     * 初始化UI
     */
    private func initUI() {
        self.navigationItem.title = "通讯录"
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
        searchController.searchBar.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: 44)
        view.addSubview(searchController.searchBar)
        view.addSubview(tableView)
    }
    
    /**
     * 添加联系人
     */
    private func addContact() {
        let addContactVC = LNAddContactVC()
        addContactVC.navigationItem.title = "新建联系人"
        let navi = UINavigationController(rootViewController: addContactVC)
        present(navi, animated: true, completion: nil)
    }
    
    /**
     * 异步获取所有联系人
     */
    fileprivate func getAllContacts() {
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
    
    /**
     * 重置所有联系人
     */
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
    
    private func detailPage(_ contact: CNContact?) {
        guard contact != nil else {
            return
        }
        
        let editVC = LNDetailVC()
        editVC.contact = contact
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // MARK:- Private Property
    private var _allContacts = [CNContact]()
}

extension LNAddressBookVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        reloadData()
    }
    
    fileprivate func reloadData() {
        query(str: searchController.searchBar.text!) { [weak self] (contacts) -> Void? in
            //回到主线程更新UI
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.resultVC.reloadWithData(data: contacts)
                }
            }
        }
    }
    
    fileprivate func query(str: String, result: @escaping ([CNContact]?) -> Void? ) {
        
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

extension LNAddressBookVC {
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kLNContactOperationCompletion), object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let weakSelf = self {
                weakSelf.getAllContacts()
            }
        }
    }
}
