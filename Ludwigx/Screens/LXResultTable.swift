//
//  LXMainTable.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

class LXMainTable: NSTableView {

  init() {
    super.init(frame: .zero)
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    configure()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }

  func configure() {
    let column = NSTableColumn()
    column.width = frame.width
    column.maxWidth = column.width
    column.minWidth = column.width
    tableColumns.reversed().forEach {
      removeTableColumn($0)
    }
    addTableColumn(column)
    selectionHighlightStyle = .none
  }
}
