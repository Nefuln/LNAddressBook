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
                
            }
        })
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(tableView)
    }
    
    private func backToLastPage() {
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.modalTransitionStyle = .crossDissolve
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:- Private property
    private lazy var tableView: LNContactTableView = {
        let tableView = LNContactTableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        return tableView
    }()

}
