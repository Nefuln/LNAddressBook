//
//  ManContactManagerExtension.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/8/2.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import Foundation
import Contacts

extension ManContactManager {
    
    /**
     * 添加联系人
     */
    public func addContact(contact: CNMutableContact) -> Bool {
        request.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(request)
            return true
        } catch {
            return false
        }
    }
    
    /**
     * 编辑联系人
     */
    public func updateContact(contact: CNMutableContact) -> Bool {
        request.update(contact)
        do {
            try store.execute(request)
            return true
        } catch {
            return false
        }
    }
    
    /**
     * 删除联系人
     */
    public func deleteContact(_ contact: CNMutableContact) -> Bool {
        request.delete(contact)
        do {
            try store.execute(request)
            return true
        } catch {
            return false
        }
    }
}
