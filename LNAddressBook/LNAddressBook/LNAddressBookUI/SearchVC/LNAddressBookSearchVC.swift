//
//  LNAddressBookSearchVC.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/30.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import Contacts

class LNAddressBookSearchVC: UIViewController {
    
    var dataArr: [CNContact]? {
        get {
            return _dataArr
        }
    }
    
    lazy var resultTableview: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.kSerachResultCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    func showBackgroundView(_ isShow: Bool) {
        resultTableview.backgroundView = isShow ? noResultView : nil
    }
    
    func reloadWithData(data: [CNContact]?) {
        showBackgroundView(data == nil || data?.count == 0)
        _dataArr  = data
        resultTableview.reloadData()
    }
    
    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        layout()
    }
    
    // MARK:- Private func
    private func initUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(resultTableview)
        self.showBackgroundView(true)
    }
    
    private func layout() {
        resultTableview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
    }
    
    // MARK:- Private property
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44))
        let label = UILabel(frame: CGRect(x: 20, y: 30, width: ScreenWidth-40, height: 10))
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "最佳匹配"
        view.addSubview(label)
        return view
    }()
    
    private lazy var noResultView: UIView = {
        let noResultView = UILabel()
        noResultView.text = "无结果"
        noResultView.textAlignment = .center
        noResultView.font = UIFont.systemFont(ofSize: 20)
        noResultView.textColor = UIColor.lightGray
        return noResultView
    }()
    
    open let kSerachResultCell = "kSerachResultCell"
    
    open var _dataArr: [CNContact]?
}


extension LNAddressBookSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_dataArr?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSerachResultCell, for: indexPath)
        cell.textLabel?.text = CNContactFormatter.string(from: (_dataArr?[indexPath.row])!, style: .fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if _dataArr == nil || _dataArr?.count == 0 {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44))
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: ScreenWidth-30, height: 10))
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "最佳匹配"
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

