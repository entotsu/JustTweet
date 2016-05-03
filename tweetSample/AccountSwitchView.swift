//
//  AccountSwitchView.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation
import Cocoa
import Accounts

class AccountSwitchView: NSView {

    let label = Label()
    var accounts: [ACAccount]!

    var fontSize: CGFloat = 12
    var height = 30

    var currentAccount: ACAccount! {
        didSet {
            label.stringValue = "@\(currentAccount.username)"
        }
    }
    var currentIndex = 0
    
    func setup(accounts: [ACAccount], width: Int) {
        self.accounts = accounts
        currentAccount = accounts.first!
        label.font = NSFont.systemFontOfSize(fontSize)
        self.addSubview(label)
        
        self.frame = CGRect(x: 0, y: 0, width: width, height: self.height)
        label.frame = self.frame
    }

    func toggleAccount() {
        currentIndex = currentIndex + 1
        if currentIndex == accounts.count {
            currentIndex = 0
        }
        currentAccount = accounts[currentIndex]
    }
}
