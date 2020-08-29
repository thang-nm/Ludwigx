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

  override var isHidden: Bool {
    didSet {
      isHidden
        ? (headerView = nil)
        : addHeader()
    }
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
    addHeader()
    addColumn()
  }

  private func addHeader() {
    headerView = NSTableHeaderView(frame: CGRect(
      origin: .zero,
      size: CGSize(width: frame.width, height: 1)
    ))
    headerView?.layer?.backgroundColor = NSColor.systemGray.cgColor
  }

  private func addColumn() {
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
