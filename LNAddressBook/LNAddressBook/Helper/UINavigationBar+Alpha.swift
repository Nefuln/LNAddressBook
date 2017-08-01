
//
//  UINavigationBar+Alpha.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/31.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setBackgroundAlpha(alpha:CGFloat)
    {
        let barBackgroundView = subviews[0]
        barBackgroundView.alpha = alpha
    }
}
