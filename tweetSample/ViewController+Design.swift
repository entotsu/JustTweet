//
//  ViewController+Design.swift
//  tweetSample
//
//  Created by 岡本 拓也 on 2016/05/06.
//  Copyright © 2016年 岡本 拓也. All rights reserved.
//

import Cocoa
import SnapKit

extension ViewController {
    
    func setupDesign() {

        guard let
            accountSwitcher = accountSwitcher,
            textField = textField,
            counter = counter
        else {
            fatalError()
        }

        view.layer?.backgroundColor = NSColor.whiteColor().CGColor

        // switcher
        accountSwitcher.margin = 8
        accountSwitcher.inactiveAlpha = 0.4
        view.addSubview(accountSwitcher)
        accountSwitcher.snp_makeConstraints { make in
            make.top.left.right.equalTo(view)
            let iconSize: CGFloat = 40
            let height = iconSize + accountSwitcher.margin * 2
            make.height.equalTo(height)
            let minimumWidth = max(accountSwitcher.getMinimumWidth(height), self.minimumWidth)
            make.width.equalTo(minimumWidth)
        }

        // text field
        textField.minHeight = 88
        textField.focusRingType = .None
        textField.bezeled = false
        view.addSubview(textField)
        textField.snp_makeConstraints { make in
            let margin: CGFloat = accountSwitcher.margin
            make.top.equalTo(accountSwitcher.snp_bottom).offset(margin / 2)
            make.bottom.right.equalTo(view).offset(-margin)
            make.left.equalTo(view).offset(margin)
        }

        // counter
        view.addSubview(counter)
        counter.layer?.opacity = 0.3
        let counterMargin: CGFloat = accountSwitcher.margin
        counter.snp_makeConstraints { make in
            make.bottom.right.equalTo(textField).offset(-counterMargin)
        }
    }
}