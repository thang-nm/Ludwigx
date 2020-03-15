//
//  LXResultSourceLabel.swift
//  Ludwigx
//
//  Created by thang-nm on 3/28/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

class LXResultSourceLabel: NSTextField {

  var onMouseDown: (() -> Void)?

  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)
    if event.type == .leftMouseDown {
      onMouseDown?()
    }
  }
}
