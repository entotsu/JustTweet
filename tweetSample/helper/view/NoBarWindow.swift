//
//  NoBarWindow.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//



//http://stackoverflow.com/questions/17779603/subviews-become-disabled-when-title-bar-is-hidden

// If you read the documentation for NSWindow you can see that the methods canBecomeKeyWindow and canBecomeMainWindow return NO if there is no title bar. Sub-classing NSWindow and over-riding these methods will make it so they can become key windows.



import Cocoa

// http://stackoverflow.com/questions/7634588/cocoa-osx-nstextfield-not-responding-to-click-for-text-editing-to-begin-when-t

class NoBarWindow: NSWindow {
    
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
}
