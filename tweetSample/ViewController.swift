//
//  ViewController.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa
import Accounts
import SnapKit

private let CHAR_COUNT_LIMIT = 140

class ViewController: NSViewController {

    var accountSwitcher: AccountSwicherView?
    var textField: AutoGrowingTextField?
    var counter: Label?
    let minimumWidth: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        getAccounts { accounts in
            guard let accounts = accounts else { return }
            // switcher
            self.accountSwitcher = AccountSwicherView()
            self.accountSwitcher!.accounts = accounts
            // text field
            self.textField = AutoGrowingTextField()
            self.textField!.delegate = self
            // counter
            self.counter = Label()
            self.counter!.stringValue = "\(CHAR_COUNT_LIMIT)"
            // actions
            self.appDelegate.didSendChangeAccountAction = { [weak self] in
                self?.accountSwitcher?.changeToPrevAccount()
            }
            self.appDelegate.didSendPostAction = { [weak self] in
                self?.post {
                    print("succeed to tweet!")
                    ToggleApp.hide()
                }
            }
            // design
            self.setupDesign()
        }
    }
    
    func setupDesign() {
        guard let
            accountSwitcher = accountSwitcher,
            textField = textField,
            counter = counter
        else {
            fatalError()
        }
        view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        // switcher
        accountSwitcher.margin = 8
        view.addSubview(accountSwitcher)
        accountSwitcher.snp_makeConstraints { make in
            make.top.left.right.equalTo(view)
            let iconSize: CGFloat = 40
            make.height.equalTo(iconSize + accountSwitcher.margin * 2)
            let minimumWidth = max(accountSwitcher.minimumWidth, self.minimumWidth)
            make.width.equalTo(minimumWidth)
        }
        accountSwitcher.layer?.borderColor = NSColor.redColor().colorWithAlphaComponent(0.1).CGColor
        accountSwitcher.layer?.borderWidth = 1
        // separator
        let separator = NSView()
        separator.layer?.backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        view.addSubview(separator)
        separator.snp_makeConstraints { make in
            make.top.equalTo(accountSwitcher.snp_bottom)
            make.height.equalTo(0.5)
            make.left.right.equalTo(view)
        }
        // text field
        textField.minHeight = 88
        textField.focusRingType = .None
        textField.bezeled = false
        view.addSubview(textField)
        textField.snp_makeConstraints { make in
            let margin: CGFloat = accountSwitcher.margin
            make.top.equalTo(separator.snp_bottom).offset(margin)
            make.bottom.right.equalTo(view).offset(-margin)
            make.left.equalTo(view).offset(margin)
        }
        // counter
        counter.layer?.opacity = 0.3
        view.addSubview(counter)
        let counterMargin: CGFloat = accountSwitcher.margin
        counter.snp_makeConstraints { make in
            make.bottom.right.equalTo(textField).offset(-counterMargin)
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
        counter.stringValue = "\(CHAR_COUNT_LIMIT - charCount)"
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
            currentAccount = self.accountSwitcher?.currentAccount
        else { return }
        let text = textField.stringValue
        guard text.characters.count <= CHAR_COUNT_LIMIT else {
            errorAlert("Tweet text length must be less than \(CHAR_COUNT_LIMIT).")
            return
        }
        textField.stringValue = ""
        self.updateCounter()
        Tweeter.tweet(text, account: currentAccount) { result in
            if let err = result.err {
                textField.stringValue = text
                errorAlert("Failed To Tweet. \(err.description)")
                return
            }
            didSuccess()
        }
    }

    private func getAccounts(completion: ([ACAccount]?->Void)) {
        Tweeter.getAccounts(
            onError: { errMsg in
                errorAlert(errMsg)
                completion(nil)
                return
            },
            onSuccess:  { accounts in
                guard accounts.count > 0 else {
                    errorAlert("Number of Twitter accounts is 0.")
                    completion(nil)
                    return
                }
                completion(accounts)
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