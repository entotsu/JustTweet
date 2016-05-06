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

    var changeAccountAction: ()->Void = {}
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

    @IBAction func changeToNextAccountAction(sender: AnyObject) {
        changeAccountAction()
    }
    
    @IBAction func postAction(sender: AnyObject) {
        postAction()
    }
    
    @IBAction func openGlobalShortcutSetting(sender: AnyObject) {
        GlobalShortcut.openSettingAlert()
    }
    
    @IBAction func changeAlpha(sender: NSMenuItem) {
        for button in sender.menu!.itemArray{
            (button ).state = NSOffState
        }
        sender.state = NSOnState
        let persentageStr = sender.title.substringToIndex(sender.title.endIndex.advancedBy(-1))
        if let persentage = Int(persentageStr) {
            let alpha = CGFloat(persentage) / CGFloat(100.0)
            changeWindowAlpha(alpha)
        }
    }
    
    func changeWindowAlpha(alpha: CGFloat) {
        let firstWindow = NSApplication.sharedApplication().windows.first
        firstWindow?.alphaValue = alpha
    }
}

