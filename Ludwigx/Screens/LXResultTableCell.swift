//
//  LXResultTableCell.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa

protocol LXResultTableCellData: class {
  func resultCellSource() -> String
  func resultCellSourceUrl() -> URL?
  func resultCellContent() -> NSAttributedString
}

protocol LXResultTableCellDelegate: class {
  func resultCellSourceClick(_ cell: LXResultTableCell)
  func resultCellUpdateAppearance(_ cell: LXResultTableCell)
}

class LXResultTableCell: NSTableCellView {

  @IBOutlet weak var sourceLabel: LXResultSourceLabel!
  @IBOutlet weak var contentLabel: NSTextField!

  var delegate: LXResultTableCellDelegate?
  private(set) weak var data: LXResultTableCellData?
  private var currentAppearance: NSAppearance?

  override func awakeFromNib() {
    super.awakeFromNib()
    bindEvents()
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    guard
      let currentAppearance = currentAppearance,
      let systemAppearance = NSAppearance.current,
      currentAppearance != systemAppearance,
      let data = data
    else { return }
    self.currentAppearance = systemAppearance
    contentLabel.attributedStringValue = data.resultCellContent()
  }

  func update(data: LXResultTableCellData) {
    self.data = data
    sourceLabel.textColor = .secondaryLabelColor
    sourceLabel.stringValue = data.resultCellSource()
    contentLabel.isSelectable = false
    contentLabel.attributedStringValue = data.resultCellContent()
    currentAppearance = NSAppearance.current
  }

  func expand() {
    contentLabel.animator().attributedStringValue = data?.resultCellContent() ?? .init(string: "")
  }

  private func bindEvents() {
    sourceLabel?.onMouseDown = { [weak self] in
      guard let self = self else { return }
      self.delegate?.resultCellSourceClick(self)
    }
  }
}
