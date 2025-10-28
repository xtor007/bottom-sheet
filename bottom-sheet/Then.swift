//
//  Then.swift
//  bottom-sheet
//
//  Created by Anatoliy Khramchenko on 28.10.2025.
//

import Foundation

protocol Then {}

extension Then {
  
  @discardableResult
  func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }

}

extension NSObject: Then {}
extension Array: Then { }
