//
//  UserDefaults.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation

class UserDefaults {

    class private var ud: Foundation.UserDefaults {
        return Foundation.UserDefaults.standard
    }

    class var selectedAccountIndex: Int {
        set {
            ud.set(newValue, forKey: "selectedAccountIndex")
        }
        get {
            return ud.integer(forKey: "selectedAccountIndex")
        }
    }
}
