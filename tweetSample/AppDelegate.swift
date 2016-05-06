//
//  AppDelegate.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/02.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var didSendChangeAccountAction: ()->Void = {}
    var didSendPostAction: ()->Void = {}

    @IBAction func changeToNextAccountAction(sender: AnyObject) {
        didSendChangeAccountAction()
    }

    @IBAction func postAction(sender: AnyObject) {
        didSendPostAction()
    }

    @IBAction func openGlobalShortcutSetting(sender: AnyObject) {
        GlobalShortcut.openSettingAlert()
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        GlobalShortcut.openSettingAlertIfNeed()
        GlobalShortcut.bind {
            ToggleApp.toggle()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

