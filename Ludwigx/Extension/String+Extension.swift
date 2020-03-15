//
//  String+Extension.swift
//  Ludwigx
//
//  Created by thang-nm on 3/25/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Foundation

extension String {

  func trim() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
