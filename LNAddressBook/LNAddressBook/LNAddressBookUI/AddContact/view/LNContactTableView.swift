//
//  LNContactTableView.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNContactTableView: UITableView {
    
    var phoneArr = [(String, String)]()
    
    public var headerView: LNContactHeaderView = {
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
        tableFooterView = footView
        tableHeaderView = headerView
        separatorStyle = .none
        
        register(LNContactCell.self, forCellReuseIdentifier: NSStringFromClass(LNContactCell.self))
        dataSource = self
        delegate = self
    }
    
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

        switch section {
        case 0:
            for (idx, obj) in self.phoneArr.enumerated() {
                let subview = LNContactCommonAddView()
                subview.set(tagTitle: "\(obj.0)\(idx)", placeholder: obj.1)
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
        self.phoneArr.append(("手机", ""))
        tableView.reloadSections(IndexSet(indexPath), with: .automatic)
    }
}
