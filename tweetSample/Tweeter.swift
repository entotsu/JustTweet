//
//  Tweeter.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation
import Accounts
import Social


class Tweeter {
    
    typealias TweeterTweetComplition = (data: NSData?, res: NSHTTPURLResponse?, err: NSError?) -> Void
    
    class func getAccounts(
        onError onError: (errorMessage: String)->Void,
        onSuccess: [ACAccount] -> Void
    ) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { granted, err in
            guard granted else {
                gcd.sync(.Main) {
                    onError(errorMessage: "Permission denied to acceess to Twitter accounts.")
                }
                return
            }
            
            let accounts = accountStore.accountsWithAccountType(accountType) as! [ACAccount]
            gcd.sync(.Main) {
                onSuccess(accounts)
            }
        }
    }
    
    class func tweet(text: String, account: ACAccount, completion: TweeterTweetComplition) {
        let apiUrlAddress = "https://api.twitter.com/1.1/statuses/update.json"
        guard let apiUrl = NSURL(string: apiUrlAddress) else {
            let errMessage = "API URL address is invalid.  -> \(apiUrlAddress)"
            let err = NSError(domain: "", code: 0, userInfo: ["message": errMessage])
            gcd.sync(.Main) {
                completion(data: nil, res: nil, err: err)
            }
            return
        }
        let request = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: SLRequestMethod.POST,
            URL: apiUrl,
            parameters: ["status": text]
        )
        request.account = account
        request.performRequestWithHandler { data, res, err in
            if let err = err {
                gcd.sync(.Main) {
                    completion(data: data, res: res, err: err)
                }
            }
            gcd.sync(.Main) {
                completion(data: data, res: res, err: nil)
            }
        }
    }
}

// Example
//
//func tweet() {
//    Tweeter.getAccounts(
//        onError: { errMsg in
//            self.errorAlert(errMsg)
//        },
//        onSuccess:  { accounts in
//            guard accounts.count > 0 else {
//                self.errorAlert("Number of Twitter accounts is 0.")
//                return
//            }
//            
//            print(accounts)
//            
//            Tweeter.tweet("test2", account: accounts[2]) { [weak self] data, res, err in
//                if let err = err {
//                    self?.errorAlert(err.description)
//                    return
//                }
//                print("tweet suceeded")
//            }
//        }
//    )
//}

