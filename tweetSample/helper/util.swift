//
//  util.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/03.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa

typealias Closure = ()->Void

func errorAlert(msg: String) {
    let alert = NSAlert()
    alert.messageText = msg
    alert.runModal()
}
