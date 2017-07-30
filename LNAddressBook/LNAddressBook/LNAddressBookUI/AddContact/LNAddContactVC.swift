//
//  LNAddContactVC.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/29.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

class LNAddContactVC: UIViewController {

    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK:- Private func
    private func initUI() {
        self.navigationItem.title = "新建联系人"
        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", image: nil, style: .plain, click: { [weak self] (item) in
            if let weakSelf = self {
                weakSelf.backToAddressBook()
            }
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", image: nil, style: .plain, click: { [weak self] (item) in
            if let weakSelf = self {
                
            }
        })
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func backToAddressBook() {
        self.navigationController?.modalTransitionStyle = .crossDissolve
        dismiss(animated: true, completion: nil)
    }

}
