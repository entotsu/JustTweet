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
        return hostUrls[currentUrlIndex].stringByReplacingOccurrencesOfString("USER_NAME", withString: username)
    }
    
    func setImageTo(iconView: NSImageView, username: String) {
        let iconUrlStr = self.getUrl(username)
        if let iconUrl = NSURL(string: iconUrlStr) {
            iconView.kf_setImageWithURL(iconUrl,
                                        placeholderImage: nil,
                                        optionsInfo: nil,
                                        progressBlock: nil)
            { result in
                if let _ = result.error {
                    self.changeUrl()
                }
            }
        }
            // url is invalid
        else {
            self.changeUrl()
        }
    }
}