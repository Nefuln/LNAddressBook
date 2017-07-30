//
//  String+Pinyin.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/30.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import Foundation

extension String {
    
    func getFirstLetterFromString() -> String {
        
        if self.characters.count == 0 {
            return ""
        }
    
        let strPinyin = self.pinyinStr()
        let index = strPinyin.index(strPinyin.startIndex, offsetBy: 1)
        let firstStr = strPinyin.substring(to: index)
        let regexA = "^[A-Z]$"
        let predA = NSPredicate(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstStr) ? firstStr : "#"
    }
    
    func pinyinStr() -> String {
        if self.characters.count == 0 {
            return ""
        }
        let mutaStr = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutaStr, nil, kCFStringTransformToLatin, false)
        let pinyinStr = (mutaStr as String).folding(options: .diacriticInsensitive, locale: NSLocale.current)
        
        let strPinyin = self.polyPhoneStringHandle(aString: self, pinyinStr: pinyinStr).uppercased()
        return strPinyin
    }
    
    private func polyPhoneStringHandle(aString: String, pinyinStr: String) -> String {
        switch aString {
        case "长":
            return "chang"
        case "沈":
            return "shen"
        case "厦":
            return "xia"
        case "地":
            return "di"
        case "重":
            return "chong"
        default:
            return pinyinStr
        }
    }
}
