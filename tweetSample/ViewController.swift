//
//  ViewController.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa
import Accounts

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
    
    override func viewDidAppear() {
        super.viewDidAppear()
        textField?.becomeFirstResponder()
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
            self.appDelegate.changeAccountToLeftAction = { [weak self] in
                self?.accountSwitcher?.changeToPrevAccount()
            }
            self.appDelegate.changeAccountToRightAction = { [weak self] in
                self?.accountSwitcher?.changeToNextAccount()
            }
            self.appDelegate.postAction = { [weak self] in
                self?.post {
                    ToggleApp.hide()
                }
            }
            // design
            self.setupDesign()
            self.textField?.becomeFirstResponder()
        }
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

// MARK: - NSTextFieldDelegate

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

// MARK: - util methods

extension ViewController {
    private var appDelegate: AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
}