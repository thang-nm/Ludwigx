//
//  LXApplication.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

class LXApplication: NSApplication {

  let appDelegate = LXAppDelegate()

  override init() {
    super.init()
    delegate = appDelegate
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    delegate = appDelegate
  }
}
