//
//  GlobalShortcut.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation
import MASShortcut

private let kPreferenceGlobalShortcut = "GlobalShortcut"

class GlobalShortcut {

    class func bind(action: @escaping ()->Void) {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: kPreferenceGlobalShortcut) {
            action()
        }
    }
    
    class func openSettingAlertIfNeed() {
        if FirstLaunchChecker.isFirstLaunch() {
            openSettingAlert()
        }
    }
    
    class func openSettingAlert() {
        guard let firstWindow = NSApplication.shared.windows.first else { return }
        let alert = NSAlert()
        alert.alertStyle = NSAlert.Style.informational
        alert.messageText = "Set Global Shortcut for Show/Hide!"
        let shortcutView = MASShortcutView()
        shortcutView.frame = NSRect(x: 0, y: 0, width: 300, height: 20)
        shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut
        alert.accessoryView = shortcutView
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: firstWindow, completionHandler: nil)
    }
}
