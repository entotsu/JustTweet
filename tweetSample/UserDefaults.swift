//
//  UserDefaults.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation

class UserDefaults {

    class private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }

    class var selectedAccountIndex: Int {
        set {
            ud.setInteger(newValue, forKey: "selectedAccountIndex")
        }
        get {
            return ud.integerForKey("selectedAccountIndex")
        }
    }
}