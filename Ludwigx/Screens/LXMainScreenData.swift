//
//  LXMainScreenData.swift
//  Ludwigx
//
//  Created by thang-nm on 3/29/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Cocoa
import LudwigxAPI

class LXMainScreenData: LAResultData {

  var isExpaded: Bool = false

  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }

  init(data: LAResultData) {
    super.init()
    snippetList = data.snippetList
    score = data.score
    match = data.match
    isExpaded = false
  }
}

// MARK: - LXResultTableCellData
extension LXMainScreenData: LXResultTableCellData {

  func resultCellSource() -> String {
    return snippetList.first?.sourceDomain.first?.domain ?? ""
  }

  func resultCellSourceUrl() -> URL? {
    if
      let string = snippetList.first?.sourceDomain.first?.urls.first,
      let url = URL(string: string)
    {
      return url
    }
    return nil
  }

  func resultCellContent() -> NSAttributedString {
    return isExpaded ? content() : briefContent()
  }

  func content() -> NSAttributedString {
    if
      let content = snippetList.first?.snippetSentences.reduce("", {$0 + " " + $1.trim() }),
      let fallback = snippetList.first?.content.reduce("", {$0 + " " + $1.trim() })
    {
      return contentAttributeString(from: content, fallback: fallback)
    }
    return NSAttributedString(string: "")
  }

  private func briefContent() -> NSAttributedString {
    if
      let content = snippetList.first?.snippetSentences[safe: 1],
      let fallback = snippetList.first?.content[safe: 1]
    {
      return contentAttributeString(from: content, fallback: fallback)
    }
    return NSAttributedString(string: "")
  }

  private func contentAttributeString(from html: String, fallback: String) -> NSAttributedString {
    let highlighColor: NSColor = match >= 99
      ? (NSColor(setName: "blue-highlight") ?? #colorLiteral(red: 0.2, green: 0.6039215686, blue: 0.9411764706, alpha: 1))
      : (NSColor(setName: "yellow-highlight") ?? #colorLiteral(red: 0.9882352941, green: 0.768627451, blue: 0.09803921569, alpha: 1))
    let textColor: NSColor = .textColor
    let style = #"""
      <style>
        html {
          color: \#(textColor.hexString);
        }
        span {
          color: \#(highlighColor.hexString);
          font-weight: bold;
        }
      </style>
    """#
    let attrString = try? NSMutableAttributedString(
      data: (style + html).data(using: .utf8)!,
      options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ],
      documentAttributes: nil
    )
    if attrString == nil {
      return NSAttributedString(string: fallback)
    }
    let range = NSRange(location: 0, length: attrString!.length)
    attrString!.addAttributes([.font: NSFont.systemFont(ofSize: NSFont.systemFontSize)], range: range)
    return attrString!
  }
}
