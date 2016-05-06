//
//  AccountSwicherView.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/03.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Foundation
import Cocoa
import Accounts

class AccountSwicherView: NSView {
    
    var accounts: [ACAccount] = [] {
        didSet {
            icons.forEach { $0.removeFromSuperview() }
            icons = generateAccountIcons(accounts)
            icons.forEach { addSubview($0) }
            currentIndex = 0
        }
    }
    var minimumWidth: CGFloat = 0
    
    private(set) var currentAccount: ACAccount?

    private var icons: [NSImageView] = []
    private var currentIndex = 0 {
        didSet {
            icons.forEach { $0.alphaValue = 0.5 }
            icons[currentIndex].alphaValue = 1
            currentAccount = accounts[currentIndex]
        }
    }
    private var iconUrlHosts = TwitterIconUrlHosts()
    
    func changeToNextAccount() {
        let nextIndex = currentIndex + 1
        if nextIndex == accounts.count {
            currentIndex = 0
            return
        }
        currentIndex = nextIndex
    }

    func changeToPrevAccount() {
        let nextIndex = currentIndex - 1
        if nextIndex < 0 {
            currentIndex = accounts.count - 1
            return
        }
        currentIndex = nextIndex
    }

    override func layout() {
        super.layout()
        let margin: CGFloat = 8
        let iconSize = self.frame.height - margin * 2
        var i = 0
        for icon in icons {
            icon.frame = CGRect(
                x: margin + (iconSize + margin) * CGFloat(i),
                y: margin,
                width: iconSize,
                height: iconSize
            )
            i = i + 1
        }
        if let lastIcon = icons.last {
            minimumWidth = lastIcon.frame.maxX + margin
        }
    }
    
    private func generateAccountIcons(accounts: [ACAccount]) -> [NSImageView] {
        var iconViews: [NSImageView] = []
        for ac in accounts {
            let iconView = NSImageView()
            iconUrlHosts.setImageTo(iconView, username: ac.username)
            iconView.wantsLayer = true
            iconView.layer!.backgroundColor = NSColor.grayColor().CGColor
            iconView.layer!.cornerRadius = 2
            iconView.layer!.masksToBounds = true
            iconViews.append(iconView)
        }
        return iconViews
    }
}

