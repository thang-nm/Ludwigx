//
//  Collection+Extension.swift
//  Ludwigx
//
//  Created by thang-nm on 3/17/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Foundation

extension Collection {

  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
