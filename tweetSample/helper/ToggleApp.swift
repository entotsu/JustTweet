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
        let app = NSApplication.shared
        if app.isActive {
            app.hide(nil)
        }
        else {
            let bundlePath = Bundle.main.bundlePath
            let appName = FileManager.default.displayName(atPath: bundlePath)
            let ws = NSWorkspace.shared
            guard let appPath = ws.fullPath(forApplication: appName) else { return }
            let url = NSURL(fileURLWithPath: appPath)
            _ = try? ws.launchApplication(at: url as URL, options: NSWorkspace.LaunchOptions.default, configuration: [NSWorkspace.LaunchConfigurationKey.arguments:[]])
        }
    }
    
    class func hide() {
        let app = NSApplication.shared
        if app.isActive {
            app.hide(nil)
        }
    }
}
