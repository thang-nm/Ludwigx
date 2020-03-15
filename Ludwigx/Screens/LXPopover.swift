//
//  LXPopover.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

protocol LXPopoverable {
  func show(opener: Any?)
  func hide(opener: Any?)
  func toggle(opener: Any?)
}

class LXPopover: NSPopover {

  init(viewController: NSViewController & LXPopoverViewController) {
    super.init()
    contentViewController = viewController
    behavior = .transient
    viewController.popover = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension LXPopover: LXPopoverable {

  func show(opener: Any?) {
    guard let sender = opener as? NSView else { return }
    show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
  }

  func hide(opener: Any?) {
    performClose(opener)
  }

  func toggle(opener: Any?) {
    isShown ? hide(opener: opener) : show(opener: opener)
  }
}
