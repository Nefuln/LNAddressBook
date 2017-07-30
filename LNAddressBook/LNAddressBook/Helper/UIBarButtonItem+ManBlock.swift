//
//  ManUIBarButtonItem.swift
//  Demo
//
//  Created by 浪漫满屋 on 2017/6/30.
//  Copyright © 2017年 Man. All rights reserved.
//

import UIKit

// MARK: - UIBarButtonItem扩展类
extension UIBarButtonItem {
    
    // MARK:- Public
    /**
     自定义构造器(图片和文本只能只能显示一个, 图片优先级更高)
     
     - parameter title: 名称
     - parameter image: 图片
     - parameter style: 类型
     - parameter click: 回调闭包
     
     - returns: 无返回值
     */
    public convenience init(title: String?, image: UIImage?, style: UIBarButtonItemStyle, click: @escaping (_: UIBarButtonItem)->Void) {
        self.init()
        self.title = title
        self.image = image
        self.click = click
        self.target = self
        self.action = #selector(onClick(_:))
    }
    
    
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, click: @escaping (_: UIBarButtonItem)->Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.click = click
        self.target = self
        self.action = #selector(onClick(_:))
    }
    
    
    // MARK:- Private
    /// 点击闭包类型定义
    private typealias ManUIBarButtonItemClick = (_: UIBarButtonItem)->Void
    
    /**
     *  点击闭包key值
     */
    private struct man_associatedKeys {
        static var manUIBarButtonItemClickKey = "manUIBarButtonItemClickKey"
    }
    
    /// 闭包属性重载
    private var click: ManUIBarButtonItemClick? {
        set {
            objc_setAssociatedObject(self, &man_associatedKeys.manUIBarButtonItemClickKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        get {
            if let result = objc_getAssociatedObject(self, &man_associatedKeys.manUIBarButtonItemClickKey) as? ManUIBarButtonItemClick {
                return result;
            }
            return nil;
        }
    }
    
    /**
     点击事件
     
     - parameter _: 当前点击的控件
     */
    @objc private func onClick(_: UIBarButtonItem) {
        if self.click != nil {
            self.click!(self)
        }
    }
    
}
