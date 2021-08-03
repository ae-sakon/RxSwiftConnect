//
//  ErrorInfo.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation

public protocol ErrorInfo {
  
  var errorCode:String? { get set }
  var errorFriendlyEn:String? { get set }
  var errorFriendlyTh:String? { get set }
  var errorInfo:String? { get set }
  
  init(error:Error)
  init(responseCode:Int)
  init(unknowError:String)
    
}
