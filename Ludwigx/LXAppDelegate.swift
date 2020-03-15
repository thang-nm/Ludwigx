//
//  LXAppDelegate.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

@NSApplicationMain
class LXAppDelegate: NSObject, NSApplicationDelegate {

  lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  lazy var popover: LXPopoverable = LXPopover(viewController: LXMainViewController())

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    configure(statusItem: statusItem)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
}

extension LXAppDelegate {

  private func configure(statusItem: NSStatusItem) {
    if let button = statusItem.button {
      button.image = #imageLiteral(resourceName: "keyboard-menubar")
      button.action = #selector(onStatusItemClick(_:))
      button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
  }

  @objc private func onStatusItemClick(_ sender: NSStatusBarButton) {
    let menu = NSMenu()
    menu.addItem(.init(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    switch NSApp.currentEvent?.type {
    case .some(.rightMouseUp): statusItem.popUpMenu(menu)
    default: popover.toggle(opener: sender)
    }
  }
}
