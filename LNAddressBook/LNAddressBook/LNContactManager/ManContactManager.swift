//
//  ManContactManager.swift
//  ManTool_Demo
//
//  Created by 浪漫满屋 on 2017/7/16.
//  Copyright © 2017年 Man. All rights reserved.
//

import Foundation
import ContactsUI

class ManContactManager: NSObject, CNContactPickerDelegate {
    
    /// 单例
    static let manager = ManContactManager()
    private override init() {}
    
    // MARK:- 跳转到通讯录页面
    private var contactSelected: ((_ contact: CNContact) -> Void)? = nil
    private var cancel: (() -> Void)? = nil
    private var contactPicker = CNContactPickerViewController()
    
//    func contactPicker(selected: @escaping (_ selected: CNContact) -> Void, cancel: @escaping () -> Void) -> Void {
//        self.contactSelected = selected
//        self.cancel = cancel
//        contactPicker.delegate = self
//        UIViewController.getCurrentVC()?.present(contactPicker, animated: true, completion: nil)
//    }
    
    // MARK:- 获取所有联系人信息
    //创建通讯录对象
    private let store = CNContactStore()
    var keys = [
//        CNContactIdentifierKey,
//        CNContactNamePrefixKey,
//        CNContactMiddleNameKey,
//        CNContactPreviousFamilyNameKey,
//        CNContactNameSuffixKey,
//        CNContactFamilyNameKey,             //姓
//        CNContactGivenNameKey,              //名
//        CNContactNicknameKey,               //昵称
//        CNContactBirthdayKey,               //生日
//        CNContactOrganizationNameKey,       //组织名称
//        CNContactJobTitleKey,               //职业
//        CNContactDepartmentNameKey,         //部门
//        CNContactNoteKey,                   //备注
//        CNContactPhoneNumbersKey,           //电话
//        CNContactEmailAddressesKey,         //email
//        CNContactPostalAddressesKey,        //邮编
//        CNContactDatesKey,                  //纪念日
//        CNContactInstantMessageAddressesKey //即时通讯地址
    CNContactIdentifierKey,
    CNContactNamePrefixKey,
    CNContactGivenNameKey,
    CNContactMiddleNameKey,
    CNContactFamilyNameKey,
    CNContactPreviousFamilyNameKey,
    CNContactNameSuffixKey,
    CNContactNicknameKey,
    CNContactOrganizationNameKey,
    CNContactDepartmentNameKey,
    CNContactJobTitleKey,
    CNContactPhoneticGivenNameKey,
    CNContactPhoneticMiddleNameKey,
    CNContactPhoneticFamilyNameKey,
    CNContactPhoneticOrganizationNameKey,
    CNContactBirthdayKey,
    CNContactNonGregorianBirthdayKey,
    CNContactNoteKey,
    CNContactImageDataKey,
    CNContactThumbnailImageDataKey,
    CNContactImageDataAvailableKey,
    CNContactTypeKey,
    CNContactPhoneNumbersKey,
    CNContactEmailAddressesKey,
    CNContactPostalAddressesKey,
    CNContactDatesKey,
    CNContactUrlAddressesKey,
    CNContactRelationsKey,
    CNContactSocialProfilesKey,
    CNContactInstantMessageAddressesKey
    ]
    
    /**
     获取所有的通讯录信息
     
     - parameter result: 通讯录信息, 获取权限失败则返回false, 成功返回true及通讯录信息
     */
    func getAllContacts(result: ((_ access: Bool, _ contacts: [CNContact]?) -> Void)?) {
        store.requestAccess(for: .contacts) { (isRight, error) in
            if !isRight {
                if result != nil {
                    result!(false, nil)
                }
                return
            }

            if result != nil {
                result!(true, self.loadContactsData())
            }
        }
    }
    
    func getAllContactsByOrder(result: ((_ access: Bool, _ contacts: ([String: [CNContact]], [String])?) -> Void)?) {
        self.getAllContacts {[weak self] (acce, cons) in
            if acce == false {
                if result != nil {
                    result!(acce, nil)
                }
                return
            }
            
            if let weakSelf = self {
                if result != nil {
                    result!(true, weakSelf.sortAllContactsByOrder(allContacts: cons))
                }
            }

        }
    }
    
    private func sortAllContactsByOrder(allContacts: [CNContact]?) -> ([String: [CNContact]], [String])? {
        guard allContacts != nil || allContacts?.count == 0 else {
            return nil
        }
        
        var mutaData = [String: [CNContact]]()
        for contact in allContacts! {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName)
            let firstLetter = fullName?.getFirstLetterFromString()
            
            if mutaData[firstLetter!] != nil {
                mutaData[firstLetter!]!.append(contact)
            } else {
                mutaData[firstLetter!] = [contact]
            }
        }
        
        var firstKeys = mutaData.keys.sorted()
        if firstKeys.contains("#") {
            let index = firstKeys.index(of: "#")
            firstKeys.remove(at: index!)
            firstKeys.append("#")
        }
        
        return (mutaData, firstKeys)
    }
    
    /**
     加载所有的联系人数据
     
     - returns: 所有联系人信息
     */
    private func loadContactsData() -> [CNContact]? {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized else {
            return nil
        }

        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        var allContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                allContacts.append(contact)
            })
        } catch {
//            MPrint(error)
        }
        
        return allContacts
    }

    
    // MARK:- CNContactPickerDelegate
    // 点击取消按钮
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        if (self.cancel != nil) {
            self.cancel!()
        }
    }
    
    // 选中联系人
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if (self.contactSelected != nil) {
            self.contactSelected!(contact)
        }
    }
}

// MARK: - 联系人分类, 转化为可见的信息
extension CNContact {
    /// 邮箱地址
    var mEmails: [[String : String]]? {
        get {
            var emails = [[String : String]]()
            for email in self.emailAddresses {
                let key = (email.label != nil) ? CNLabeledValue<NSString>.localizedString(forLabel: email.label!) : "email"
                emails.append([key : email.value as String])
            }
            return emails
        }
    }
    
    /// 电话
    var mPhones: [[String : String]]? {
        get {
            var phones = [[String : String]]()
            for phone in self.phoneNumbers {
                let key = (phone.label != nil) ? CNLabeledValue<NSString>.localizedString(forLabel: phone.label!) : "phone"
                phones.append([key : phone.value.stringValue])
            }
            return phones
        }
    }
    
    /// 地址
    var mAddress: [[String : ManContactAddressModel]]? {
        get {
            var addresss = [[String : ManContactAddressModel]]()
            for address in self.postalAddresses {
                let key = (address.label != nil) ? CNLabeledValue<NSString>.localizedString(forLabel: address.label!) : "address"
                
                let detail = address.value
                let addressModel = ManContactAddressModel()
                
                addressModel.country = detail.value(forKey: CNPostalAddressCountryKey) as? String ?? ""
                addressModel.province = detail.value(forKey: CNPostalAddressStateKey) as? String ?? ""
                addressModel.city = detail.value(forKey: CNPostalAddressCityKey) as? String ?? ""
                addressModel.street = detail.value(forKey: CNPostalAddressStreetKey) as? String ?? ""
                addressModel.postalCode = detail.value(forKey: CNPostalAddressPostalCodeKey) as? String ?? ""
                
                addresss.append([key : addressModel])
            }
            return addresss;
        }
    }
    
    /// 纪念日
    var mDates: [[String : Date]]? {
        get {
            var dates = [[String : Date]]()
            for date in self.dates {
                let key = date.label != nil ? CNLabeledValue<NSString>.localizedString(forLabel: date.label!) : "date"
                let value: Date? = NSCalendar.current.date(from: date.value as DateComponents)
                if (value != nil) {
                    dates.append([key : value!])
                }
            }
            return dates
        }
    }
    
    var mBirthday: Date? {
        get {
            return self.birthday != nil ? NSCalendar.current.date(from: self.birthday!) : nil
        }
    }
    
    /// 即时通讯信息
    var mIms: [[String : ManContactMsgAddressModel]]? {
        get {
            var ims = [[String : ManContactMsgAddressModel]]()
            for im in self.instantMessageAddresses {
                let key = im.label != nil ? CNLabeledValue<NSString>.localizedString(forLabel: im.label!) : "messageAddress"
                
                let msgAddressModel = ManContactMsgAddressModel()
                let detail = im.value
                msgAddressModel.username = detail.value(forKey: CNInstantMessageAddressUsernameKey) as? String ?? ""
                msgAddressModel.service = detail.value(forKey: CNInstantMessageAddressServiceKey) as? String ?? ""
                ims.append([key : msgAddressModel])
            }
            return ims
        }
    }
    
    /// 重写description
    open override var description: String {
        return "\n姓名: \(self.familyName) \(self.givenName)\n昵称: \(self.nickname)\n职位: \(self.organizationName)\(self.departmentName)\(self.jobTitle)\n电话: \(String(describing: self.mPhones))\nemail: \(String(describing: self.mEmails))\n纪念日: \(String(describing: self.mDates))\n即时通讯信息: \(String(describing: self.mIms))\n地址: \(String(describing: self.mAddress))\n生日: \(String(describing: self.mBirthday))"
    }
}

/// 联系人地址模型
class ManContactAddressModel: NSObject {
    var country: String?            //国家
    var province: String?           //省份
    var city: String?               //城市
    var street: String?             //街道
    var postalCode: String?         //邮编
    var address: String?            //地址
}

/// 联系人即时通讯信息模型
class ManContactMsgAddressModel: NSObject {
    var username: String?           //用户名
    var service: String?            //服务地址
}

