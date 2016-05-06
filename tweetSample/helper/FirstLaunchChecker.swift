//
//  FirstLaunchChecker.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation

class FirstLaunchChecker {
    class func isFirstLaunch() -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return false
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return true
        }
    }
}