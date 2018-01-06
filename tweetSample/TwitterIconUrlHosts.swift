//
//  TwitterIconUrlHosts.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/03.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa
import Kingfisher

class TwitterIconUrlHosts {
    
    private let hostUrls = [
        "http://twiticon.herokuapp.com/USER_NAME",
        "http://www.paper-glasses.com/api/twipi/USER_NAME/normal",
        "http://furyu.nazo.cc/twicon/USER_NAME/normal"
    ]
    
    private var currentUrlIndex = 0
    
    func changeUrl() -> Bool {
        if currentUrlIndex + 1 < hostUrls.count {
            currentUrlIndex = currentUrlIndex + 1
            return false
        }
        return true
    }
    
    func getUrl(username: String) -> String {
        return hostUrls[currentUrlIndex].replacingOccurrences(of: "USER_NAME", with: username)
    }
    
    func setImageTo(iconView: NSImageView, username: String) {
        let iconUrlStr = self.getUrl(username: username)
        if let iconUrl = URL(string: iconUrlStr) {
            iconView.kf.setImage(with: iconUrl,
                                 placeholder: nil,
                                 options: nil,
                                 progressBlock: nil)
            { img, err, cacheType, url in
                if let _ = err {
                    if self.changeUrl() {
                        self.setImageTo(iconView: iconView, username: username)
                    }
                }
            }
        }
            // url is invalid
        else {
            if self.changeUrl() {
                self.setImageTo(iconView: iconView, username: username)
            }
        }
    }
}
