//
//  ViewController+Design.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/03.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa
import Accounts
import SnapKit

extension ViewController {

    func addAccountView(accounts: [ACAccount]) -> AccountSwitchView {
        let accountsView = AccountSwitchView()
        self.view.addSubview(accountsView)
        accountsView.setup(accounts, width: Int(self.view.frame.width))
        accountsView.layer?.borderColor = NSColor.redColor().CGColor
        accountsView.layer?.borderWidth = 4
        accountsView.frame.origin = CGPoint(
            x: 0,
            y: self.view.frame.height - accountsView.frame.height
        )
        return accountsView
    }

    // ↓
    
    func addTextField() -> NSTextField {
        let textField = NSTextField()
        textField.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: self.view.frame.height - self.accountsView!.frame.height
        )
        self.view.addSubview(textField)
        
        textField.layer?.borderColor = NSColor.blueColor().CGColor
        textField.layer?.borderWidth = 4
        
        return textField
    }

    func addCharCounter() -> Label {
        let counter = Label()
        view.addSubview(counter)
        let margin: CGFloat = 8
        counter.snp_makeConstraints { make in
            make.bottom.right.equalTo(self.textField!).offset(-margin)
        }
        return counter
    }
}