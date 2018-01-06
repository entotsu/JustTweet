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
            icons = generateAccountIcons(accounts: accounts)
            icons.forEach { addSubview($0) }
            let cachedIndex = UserDefaults.selectedAccountIndex
            currentIndex = min(cachedIndex, accounts.count - 1)
        }
    }
    var margin: CGFloat = 8
    var inactiveAlpha: CGFloat = 0.4

    private(set) var currentAccount: ACAccount?

    private var icons: [NSImageView] = []
    private var currentIndex = 0 {
        didSet {
            icons.forEach { $0.alphaValue = inactiveAlpha }
            icons[currentIndex].alphaValue = 1
            currentAccount = accounts[currentIndex]
            UserDefaults.selectedAccountIndex = currentIndex
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
    }
    
    func getMinimumWidth(heightOfThisView: CGFloat) -> CGFloat {
        let iconSize = heightOfThisView - margin * 2
        return margin + (iconSize + margin) * CGFloat(icons.count)
    }
    
    private func generateAccountIcons(accounts: [ACAccount]) -> [NSImageView] {
        var iconViews: [NSImageView] = []
        var i = 0
        for ac in accounts {
            let iconView = NSImageView()
            iconUrlHosts.setImageTo(iconView: iconView, username: ac.username)
            iconView.wantsLayer = true
            iconView.layer!.backgroundColor = NSColor.gray.cgColor
            iconView.layer!.cornerRadius = 2
            iconView.layer!.masksToBounds = true
            iconView.tag = i
            iconView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(self.didClickIcon(sender:))))
            iconViews.append(iconView)
            i = i + 1
        }
        return iconViews
    }
    
    @objc func didClickIcon(sender: NSClickGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        currentIndex = index
    }
}

