//
//  RawResponse.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation

public struct RawResponse {
  
  public var statusCode:Int
  public var data:Data?
  
  init(statusCode:Int, data:Data?) {
    self.statusCode = statusCode
    self.data       = data
  }
}
