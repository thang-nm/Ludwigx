//
//  LXMainViewController.swift
//  Ludwigx
//
//  Created by thang-nm on 3/15/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa
import LudwigxAPI

protocol LXPopoverViewController: class {
  var popover: NSPopover? { get set }
}

class LXMainViewController: NSViewController, LXPopoverViewController {

  @IBOutlet weak var searchView: NSView!
  @IBOutlet weak var searchTextField: LXSearchField!
  @IBOutlet weak var loader: NSProgressIndicator!
  @IBOutlet weak var messageLabeL: NSTextField!
  @IBOutlet weak var resultView: NSView!
  @IBOutlet weak var resultTable: LXMainTable!

  var popover: NSPopover?
  private var data: [LXMainScreenData]?
  private var observation: NSKeyValueObservation?
  private var defaultHeight: CGFloat = 74
  private var maxHeight: CGFloat = 420
  private var minHeight: CGFloat = 104
  private var resetTimer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()
    configure(view: view)
    configure(searchField: searchTextField)
    configure(tableView: resultTable)
    updateFrame(height: searchView.frame.height)
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    searchTextField.becomeFirstResponder()
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    resetTimer?.invalidate()
    resetTimer = nil
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()
    createResetTimer()
  }

  deinit {
    observation?.invalidate()
    resetTimer?.invalidate()
  }
}

extension LXMainViewController {

  @IBAction func close(_ sender: NSButton) {
    popover?.close()
  }

  @IBAction func pin(_ sender: NSButton) {
    if popover?.behavior == .some(.transient) {
      popover?.behavior = .applicationDefined
      sender.image = #imageLiteral(resourceName: "chevron-down")
    } else {
      popover?.behavior = .transient
      sender.image = #imageLiteral(resourceName: "chevron-up")
    }
  }
}

extension LXMainViewController {

  private func configure(view: NSView) {
    if #available(OSX 10.14, *) {
      observation = NSApp.observe(\.effectiveAppearance, options: [.old, .new]) { (object, change) in
        NSAppearance.current = object.effectiveAppearance
      }
    }
  }

  private func configure(searchField: LXSearchField) {
    searchField.lxDelegate = self
  }

  private func configure(tableView: NSTableView) {
    tableView.register(class: LXResultTableCell.self)
    tableView.dataSource = self
    tableView.delegate = self
  }

  private func search(text: String) {
    loading()
    LALudwigxAPI().search(text: text) { [weak self] (result, error) in
      DispatchQueue.main.async {
        self?.updateResult(result, error)
      }
    }
  }

  private func updateResult(_ result: LASearchResponse?, _ error: LALudwigxAPIError?) {
    if error != nil || result == nil {
      alert(message: "Something went wrong! Please try again.")
      return
    }

    if result!.resultDataList.count == 0 {
      alert(message: "No results!")
      return
    }

    data = result?.resultDataList.map({ LXMainScreenData(data: $0) }) ?? []
    loader.stopAnimation(nil)
    loader.isHidden = true
    messageLabeL.isHidden = true
    resultTable.isHidden = false
    resultTable.reloadData()

    updateFrame(height: searchView.frame.height
      + resultTable.intrinsicContentSize.height > maxHeight
        ? maxHeight
        : resultTable.intrinsicContentSize.height)

    DispatchQueue.main.async {
      self.resultTable.scrollTo(row: 0, animated: true)
    }
  }

  private func alert(message: String) {
    loader.isHidden = true
    resultTable.isHidden = true
    messageLabeL.isHidden = false
    messageLabeL.stringValue = message
    updateFrame(height: minHeight)
  }

  private func loading() {
    loader.isHidden = false
    loader.startAnimation(nil)
    resultTable.isHidden = true
    messageLabeL.isHidden = true
    resultTable.isHidden = true
    updateFrame(height: minHeight)
  }

  private func updateFrame(height: CGFloat) {
    NSAnimationContext.runAnimationGroup({ (context) in
      context.allowsImplicitAnimation = true
      DispatchQueue.main.async {
        self.popover?.contentSize = .init(width: self.resultTable.frame.width, height: height)
      }
    }, completionHandler: nil)
  }

  private func createResetTimer() {
    let timer = Timer(
      fireAt: .init(timeIntervalSinceNow: 300),
      interval: 0,
      target: self,
      selector: #selector(resetView),
      userInfo: nil,
      repeats: false)
    self.resetTimer = timer
    RunLoop.current.add(timer, forMode: .default)
  }

  @objc
  private func resetView() {
    searchTextField.stringValue = ""
    data = nil
    resultTable.reloadData()
    messageLabeL.isHidden = true
    loader.isHidden = true
    resultTable.isHidden = true
    updateFrame(height: defaultHeight)
    resetTimer?.invalidate()
    resetTimer = nil
  }
}

// MARK: - NSTableViewDataSource
extension LXMainViewController: NSTableViewDataSource {

  func numberOfRows(in tableView: NSTableView) -> Int {
    return data?.count ?? 0
  }
}

// MARK: - NSTableViewDelegate
extension LXMainViewController: NSTableViewDelegate {

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard
      let cell: LXResultTableCell = tableView.make(),
      let data: LXResultTableCellData = data?[row]
    else {
      fatalError()
    }
    cell.update(data: data)
    cell.delegate = self
    return cell
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    if
      let row = resultTable.rowView(atRow: resultTable.selectedRow, makeIfNecessary: true),
      let cell = row.subviews.filter({ $0 is LXResultTableCell }).first as? LXResultTableCell
    {
      data?[resultTable.selectedRow].isExpaded = true
      cell.expand()
      resultTable.noteHeightOfRows(withIndexesChanged: .init([resultTable.selectedRow]))
    }
  }
}

// MARK: - NSSearchFieldDelegate
extension LXMainViewController: LXSearchFieldDelegate {

  func searchFieldDidEnter(_ searchField: LXSearchField, text: String) {
    if !text.isEmpty {
      search(text: text)
    }
  }
}

// MARK: - LXResultTableCellDelegate
extension LXMainViewController: LXResultTableCellDelegate {

  func resultCellSourceClick(_ cell: LXResultTableCell) {
    if let url = cell.data?.resultCellSourceUrl() {
      NSWorkspace.shared.open(url)
    }
  }

  func resultCellUpdateAppearance(_ cell: LXResultTableCell) {
    if let data = cell.data {
      cell.contentLabel.animator().attributedStringValue = data.resultCellContent()
    }
  }
}
