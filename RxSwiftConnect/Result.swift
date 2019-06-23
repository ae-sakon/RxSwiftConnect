//
//  Result.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation

public enum Result<ValueObject, ErrorObject> {
  case none
  case successful(ValueObject)
  case failure(ErrorObject)
  
  public var value:ValueObject? {
    switch self {
    case .successful(let obj):
      return obj
    default:
      return nil
    }
  }
  
  public var error:ErrorObject? {
    
    switch self {
    case .failure(let obj):
      return obj
    default:
      return nil
    }
  }
}
