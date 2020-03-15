//
//  NSColor+Extension.swift
//  Ludwigx
//
//  Created by thang-nm on 3/25/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import AppKit.NSColor

extension NSColor {

  convenience init?(setName: String) {
    if #available(OSX 10.13, *) {
      self.init(named: setName)
    } else {
      return nil
    }
  }

  // @see https://stackoverflow.com/questions/15887582
  var hexString: String {
    guard let rgbColor = usingColorSpaceName(NSColorSpaceName.calibratedRGB) else {
      return "#FFFFFF"
    }
    let red = Int(round(rgbColor.redComponent * 0xFF))
    let green = Int(round(rgbColor.greenComponent * 0xFF))
    let blue = Int(round(rgbColor.blueComponent * 0xFF))
    let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
    return hexString as String
  }
}
