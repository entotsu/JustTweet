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
    
    typealias TweeterGetAccountComplition = (accounts: [ACAccount], errorMessage: String?) -> Void
    typealias TweeterTweetComplition = (data: NSData?, res: NSHTTPURLResponse?, err: NSError?) -> Void
    
    func getAccounts(
        onError onError: (errorMessage: String)->Void,
        onSuccess: [ACAccount] -> Void
    ) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { granted, err in
            guard granted else {
                onError(errorMessage: "Permission denied to acceess to Twitter accounts.")
                return
            }
            
            let accounts = accountStore.accountsWithAccountType(accountType) as! [ACAccount]
            onSuccess(accounts)
        }
    }
    
    func tweet(text: String, account: ACAccount, completion: TweeterTweetComplition) {
        let apiUrlAddress = "https://api.twitter.com/1.1/statuses/update.json"
        guard let apiUrl = NSURL(string: apiUrlAddress) else {
            let errMessage = "API URL address is invalid.  -> \(apiUrlAddress)"
            let err = NSError(domain: "", code: 0, userInfo: ["message": errMessage])
            completion(data: nil, res: nil, err: err)
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
                completion(data: data, res: res, err: err)
            }
            completion(data: data, res: res, err: nil)
        }
    }
}
