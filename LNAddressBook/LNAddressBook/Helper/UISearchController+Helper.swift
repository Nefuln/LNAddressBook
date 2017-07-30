//
//  UISearchController+Helper.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/30.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

extension UISearchController {
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.setCancelButtonTitle(title: "取消")
    }
}

extension UISearchBar {
    func setCancelButtonTitle(title: String) {
        if let cancelBtn = self.value(forKey : "cancelButton") as? UIButton {
            cancelBtn.setTitle("取消", for: .normal)
        }
    }
    
    func setCancelButtonColor(color: UIColor, state: UIControlState = .normal) {
        if let cancelBtn = self.value(forKey : "cancelButton") as? UIButton {
            cancelBtn.setTitleColor(color, for: state)
        }
    }
}
