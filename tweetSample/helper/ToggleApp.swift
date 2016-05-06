//
//  ToggleApp.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation
import Cocoa

class ToggleApp {

    class func toggle() {
        let app = NSApplication.sharedApplication()
        if app.active {
            app.hide(nil)
        }
        else {
            let bundlePath = NSBundle.mainBundle().bundlePath
            let appName = NSFileManager.defaultManager().displayNameAtPath(bundlePath)
            let ws = NSWorkspace.sharedWorkspace()
            guard let appPath = ws.fullPathForApplication(appName) else { return }
            let url = NSURL(fileURLWithPath: appPath)
            _ = try? ws.launchApplicationAtURL(url, options: NSWorkspaceLaunchOptions.Default, configuration: [NSWorkspaceLaunchConfigurationArguments:[]])
        }
    }
    
    class func hide() {
        let app = NSApplication.sharedApplication()
        if app.active {
            app.hide(nil)
        }
    }
}