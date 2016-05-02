//
//  ViewController.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tweeter = Tweeter()

        tweeter.getAccounts { accounts, errMsg in
            if let errMsg = errMsg {
                self.errorAlert(errMsg)
                return
            }
            guard accounts.count > 0 else {
                self.errorAlert("Number of Twitter accounts is 0.")
                return
            }
            
            print(accounts)
            
            tweeter.tweet("test2", account: accounts[2]) { [weak self] data, res, err in
                if let err = err {
                    self?.errorAlert(err.description)
                    return
                }
                print("tweet suceeded 👍")
            }
        }
    }
    
    func errorAlert(msg: String) {
        let alert = NSAlert()
        alert.messageText = msg
        alert.runModal()
    }
}
