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

    var changeAccountToRightAction: ()->Void = {}
    var changeAccountToLeftAction: ()->Void = {}
    var postAction: ()->Void = {}
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        GlobalShortcut.openSettingAlertIfNeed()
        GlobalShortcut.bind {
            ToggleApp.toggle()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func changeAccountToRight(sender: AnyObject) {
        changeAccountToRightAction()
    }

    @IBAction func changeAccountToLeft(sender: AnyObject) {
        changeAccountToLeftAction()
    }
    
    @IBAction func postAction(sender: AnyObject) {
        postAction()
    }
    
    @IBAction func openGlobalShortcutSetting(sender: AnyObject) {
        GlobalShortcut.openSettingAlert()
    }
    
    @IBAction func changeAlpha(sender: NSMenuItem) {
        for button in sender.menu!.items{
            (button ).state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        let persentageStr = String(sender.title.dropLast())
        if let persentage = Int(persentageStr) {
            let alpha = CGFloat(persentage) / CGFloat(100.0)
            changeWindowAlpha(alpha: alpha)
        }
    }
    
    func changeWindowAlpha(alpha: CGFloat) {
        let firstWindow = NSApplication.shared.windows.first
        firstWindow?.alphaValue = alpha
    }
}

