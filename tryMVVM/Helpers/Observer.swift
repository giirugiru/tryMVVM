//
//  Observer.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import Foundation

class Observable<T> {
  var value: T? {
    didSet {
      listener?(value)
    }
  }
  
  init (_ value: T?) {
    self.value = value
  }
  
  private var listener: ((T?) -> Void)?
  
  func bind(_ listener: @escaping (T?) -> Void) {
    listener(value)
    self.listener = listener
  }
}