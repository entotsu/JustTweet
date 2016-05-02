//
//  ViewController.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var accountsView: AccountSwitchView?
    var textField: NSTextField?
    var appDelegate: AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func post(didSuccess: Closure) {
        guard let
            textField = self.textField,
            accountsView = self.accountsView
        else { return }
        let text = textField.stringValue
        guard text.characters.count <= 140 else {
            errorAlert("Tweet text length must be less than 140.")
            return
        }
        Tweeter.tweet(text, account: accountsView.currentAccount) { result in
            if let err = result.err {
                errorAlert("Failed To Tweet. \(err.description)")
                return
            }
            textField.stringValue = ""
            didSuccess()
        }
    }
    
    func setup() {
        setupAccountsView {
            self.textField = self.addTextField(startY: self.accountsView!.frame.height)
            self.appDelegate.didSendPostAction = { [weak self] in
                self?.post {
                    print("finish")
                }
            }
        }
    }
    
    func setupAccountsView(completion: Closure? = nil) {
        Tweeter.getAccounts(
        onError: { errMsg in
            errorAlert(errMsg)
        },
        onSuccess:  { accounts in
            guard accounts.count > 0 else {
                errorAlert("Number of Twitter accounts is 0.")
                return
            }
            let accountsView = self.addAccountView(accounts)
            self.accountsView = accountsView
            // set keyboard shortcut
            self.appDelegate.didSendChangeAccountAction = { [weak self] in
                self?.accountsView!.toggleAccount()
            }
            completion?()
        })
    }
}