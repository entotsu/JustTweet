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
    
    typealias TweeterTweetComplition = (_ data: Data?, _ res: HTTPURLResponse?, _ err: Error?) -> Void
    
    class func getAccounts(
        onError: @escaping (_ errorMessage: String) -> Void,
        onSuccess: @escaping ([ACAccount]) -> Void
    ) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { granted, err in
            guard granted else {
                DispatchQueue.main.sync {
                    onError("Permission denied to acceess to Twitter accounts.")
                }
                return
            }
            
            let accounts = accountStore.accounts(with: accountType) as! [ACAccount]
            DispatchQueue.main.sync {
                onSuccess(accounts)
            }
        }
    }
    
    class func tweet(text: String, account: ACAccount, completion: @escaping TweeterTweetComplition) {
        let apiUrlAddress = "https://api.twitter.com/1.1/statuses/update.json"
        guard let apiUrl = NSURL(string: apiUrlAddress) else {
            let errMessage = "API URL address is invalid.  -> \(apiUrlAddress)"
            let err = NSError(domain: "", code: 0, userInfo: ["message": errMessage])
            DispatchQueue.main.sync {
                completion(nil, nil, err)
            }
            return
        }
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: apiUrl as URL, parameters: ["status": text])
        request?.account = account
        request?.perform { data, res, err in
            if let err = err {
                DispatchQueue.main.sync {
                    completion(data, res, err)
                }
            }
            DispatchQueue.main.sync {
                completion(data, res, nil)
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

