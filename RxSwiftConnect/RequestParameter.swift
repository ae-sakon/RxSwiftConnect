//
//  RequestModel.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation

public struct RequestParameterDefault {
  
  public var baseUrl:String?
}

public struct RequestParameter {
  
  //public static var defaults:RequestParameterDefault = RequestParameterDefault()
  
  public enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
  }
  
  var baseUrl:String
  var httpMethod:HttpMethod
  var path:String
  var query:[String:Any]?
  var payload:[String:Any?]?
  var headers:[String:String]?
  
  public init(
    httpMethod:HttpMethod,
    path:String,
    baseUrl:String,
    query:[String:Any]? = nil,
    payload:[String:Any?]? = nil,
    headers:[String:String]? = nil) {
    
    self.baseUrl = baseUrl
    self.httpMethod = httpMethod
    self.path = path
    self.query = query
    self.payload = payload
    self.headers = headers
  }
}

extension RequestParameter {
  
  public func asURLRequest() -> URLRequest {
    
    let url = "\(baseUrl)/\(path)"
    
    var components = URLComponents(string: url)
    if let qItems = query {
      let queryItems:[URLQueryItem] = qItems.reduce([], { (result, current) -> [URLQueryItem] in
        var _result = result
        _result.append(URLQueryItem(name: current.key, value: "\(current.value)"))
        return _result
      })
      components?.queryItems = queryItems
    }
    
    var request = URLRequest(url: (components?.url!)!)
    request.httpMethod = httpMethod.rawValue
    
    if payload != nil,
      let payloadData = try? JSONSerialization
        .data(withJSONObject: payload!,
              options: []) {
      request.httpBody = payloadData
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    headers?
      .enumerated()
      .forEach {
        request.addValue($0.element.value,
                         forHTTPHeaderField: $0.element.key)
    }
    return request
  }
}
