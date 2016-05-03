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
    var counter: Label?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {

        setupAccountsView { accountsView in
            self.accountsView = accountsView
            
            self.textField = self.addTextField()
            self.textField!.delegate = self

            self.counter = self.addCharCounter()
            self.counter!.stringValue = "0"

            self.appDelegate.didSendPostAction = { [weak self] in
                self?.post {
                    print("succeed to tweet!")
                }
            }
        }
    }
}

extension ViewController: NSTextFieldDelegate {

    func updateCounter() {
        guard let
            counter = self.counter,
            charCount = self.textField?.stringValue.characters.count
        else {
            return
        }
        counter.stringValue = "\(charCount)"
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        updateCounter()
    }
    
    // return key is newline
    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            textView.insertNewlineIgnoringFieldEditor(self)
            return true
        }
        else if commandSelector == #selector(NSResponder.insertTab(_:)) {
            textView.insertTabIgnoringFieldEditor(self)
            return true
        }
        return false
    }
}


// MARK: - main methods

extension ViewController {

    private func post(didSuccess: Closure) {
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
            self.updateCounter()
            didSuccess()
        }
    }

    private func setupAccountsView(completion: (AccountSwitchView->Void)? = nil) {
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
                // set keyboard shortcut
                self.appDelegate.didSendChangeAccountAction = { [weak self] in
                    self?.accountsView!.toggleAccount()
                }
                completion?(accountsView)
            }
        )
    }
}


// MARK: - util methods

extension ViewController {
    private var appDelegate: AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
}