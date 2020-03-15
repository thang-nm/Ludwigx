//
//  NSTable+Extension.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

extension NSTableCellView {

  static var identifier: String {
    return String(describing: self)
  }
}

extension NSTableView {

  func register(class: NSTableCellView.Type) {
    let name = `class`.identifier
    if let _ = Bundle.main.url(forResource: name, withExtension: "nib") {
      let nib = NSNib(nibNamed: name, bundle: nil)
      register(nib, forIdentifier: .init(name))
      return
    }
    fatalError()
  }

  func make<T: NSTableCellView>() -> T? {
    return makeView(withIdentifier: .init(T.identifier), owner: nil) as? T
  }

  // @see https://gist.github.com/kgn/1558664/e52b6d14625e0665332b805cb08e06785805ba6d
  func scrollTo(row: Int, animated: Bool = true) {
    guard let viewRect = superview?.frame else {
      scrollRowToVisible(row)
      return
    }

    let rowRect = rect(ofRow: row)
    var scrollOrigin = rowRect.origin
    let originY = scrollOrigin.y + (rowRect.size.height - viewRect.size.height) / 2
    scrollOrigin.y = originY < 0 ? 0 : originY
    superview?.animator().setBoundsOrigin(scrollOrigin)
  }
}
