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
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

