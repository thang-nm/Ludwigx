//
//  LXSearchField.swift
//  Ludwigx
//
//  Created by thang-nm on 3/28/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

protocol LXSearchFieldDelegate: class {
  func searchFieldDidEnter(_ searchField: LXSearchField, text: String)
}

class LXSearchField: NSSearchField {

  weak var lxDelegate: LXSearchFieldDelegate?

  // @see https://blog.kulman.sk/making-copy-paste-work-with-nstextfield/
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    guard event.type == .keyDown else {
      return super.performKeyEquivalent(with: event)
    }

    if event.characters == "\r" {
      lxDelegate?.searchFieldDidEnter(self, text: stringValue)
      return true
    }

    guard event.modifierFlags.contains(.command) else {
      return super.performKeyEquivalent(with: event)
    }

    var action: Selector?
    switch event.characters {
    case "x": action = #selector(NSText.cut(_:))
    case "c": action = #selector(NSText.copy(_:))
    case "v": action = #selector(NSText.paste(_:))
    case "a": action = #selector(NSText.selectAll(_:))
    default: break
    }

    if let action = action, NSApp.sendAction(action, to: nil, from: self) {
      return true
    }

    return super.performKeyEquivalent(with: event)
  }
}
