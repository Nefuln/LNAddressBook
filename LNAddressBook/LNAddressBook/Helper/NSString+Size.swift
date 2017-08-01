//
//  NSString+Size.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/1.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

extension String {
    
    public func ln_height(font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize), constrailnedToWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> Double {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        let attributes = [NSFontAttributeName : font,
                          NSParagraphStyleAttributeName : paragraph
                          ]
        let textSize = (self as NSString).boundingRect(with: CGSize(width: constrailnedToWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes, context: nil).size
        return ceil(Double(textSize.height))
    }
    
    public func ln_width(font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize), constrainedToHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> Double {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        let attributes = [NSFontAttributeName : font,
                          NSParagraphStyleAttributeName : paragraph
        ]
        let textSize = (self as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: constrainedToHeight), options: options, attributes: attributes, context: nil).size
        return ceil(Double(textSize.width))
    }
    
    public func ln_size(font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize), constrailnedToWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        let attributes = [NSFontAttributeName : font,
                          NSParagraphStyleAttributeName : paragraph
        ]
        let textSize = (self as NSString).boundingRect(with: CGSize(width: constrailnedToWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes, context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
}
