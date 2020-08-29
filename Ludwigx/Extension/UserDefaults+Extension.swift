//
//  UserDefaults+Extension.swift
//  Ludwigx
//
//  Created by Langle on 8/29/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Foundation

enum StorageKey: String {
  case pinned = "setting.pinned"
}

extension UserDefaults {

  func read<T>(key: StorageKey) -> T? {
    return object(forKey: key.rawValue) as? T
  }

  func write<T>(key: StorageKey, value: T?) {
    set(value, forKey: key.rawValue)
  }
}
