//
//  LNAddressBookTableView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/30.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit
import SnapKit
import Contacts

class LNAddressBookTableView: UITableView {
    
    // MARK:- Public property
    var dataArr: [String: [CNContact]]?
    var sectionIndex: [String]?
    var cellDidSelectedBlock: ((_ contact: CNContact) -> Void)? = nil
    
    // MARK:- Public func
    func reloadWithData(_ dataArr: [String: [CNContact]]?, indexs: [String]?) {
        self.dataArr = dataArr
        self.sectionIndex = indexs
        
        guard dataArr != nil && indexs != nil else {
            return
        }
        
        footView.setCount(dataArr!.count)
        reloadData()
    }

    // MARK:- Override
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private
    private func setup() {
        tableFooterView = footView
        register(UITableViewCell.self, forCellReuseIdentifier: kAddressBookCell)
        dataSource = self
        delegate = self
        
        //设置索引
        sectionIndexColor = UIColor.blue
        // 设置选中时的索引背景颜色
        sectionIndexTrackingBackgroundColor = UIColor.white
        // 设置索引的背景颜色
        sectionIndexBackgroundColor = UIColor.white

    }
    
    // MARK:- Private Property
    private let footView: LNAddressBookFootView = {
        let view = LNAddressBookFootView(height: 50)
        return view
    }()
    
    let kAddressBookCell = "kAddressBookCell"

}

///联系人列表协议处理
extension LNAddressBookTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionIndex?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDataArr = self.sectionIndex?[section]
        return self.dataArr![sectionDataArr!]!.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kAddressBookCell, for: indexPath)
        let contact: CNContact = (self.dataArr?[(self.sectionIndex?[indexPath.section])!]![indexPath.row])!
        let fullName = CNContactFormatter.string(from: contact, style: .fullName)
        cell.textLabel?.text = fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        let label = UILabel()
        headerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(headerView)
            make.left.equalTo(headerView.snp.left).offset(20)
        }
        label.text = "\(self.sectionIndex?[section] ?? "")"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.cellDidSelectedBlock != nil) {
            let contact: CNContact = (self.dataArr?[(self.sectionIndex?[indexPath.section])!]![indexPath.row])!
            cellDidSelectedBlock!(contact)
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndex
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

/// 联系人列表footview
class LNAddressBookFootView: UILabel {
    
    // MARK:- Public func
    public func setCount(_ count: NSInteger) {
        text = "\(count)位联系人"
    }
    
    // MARK:- init
    init(height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private func 
    private func initUI() {
        textAlignment = .center
        textColor = UIColor.lightGray
        font = UIFont.systemFont(ofSize: 20)
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset((15))
            make.right.top.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK:- Private Property
    private lazy var topLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
}
