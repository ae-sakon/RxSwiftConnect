//
//  RequestModel.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif


public struct RequestParameterDefault {
  
  public var baseUrl:String?
}

public struct RequestParameter {
  
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
  var query:[String:Any?]?
  var payload:[String:Any?]?
  var headers:[String:String]?
  var version:String
  let hasVersion:Bool

  
  public init(
    httpMethod:HttpMethod,
    path:String,
    baseUrl:String,
    query:[String:Any?]? = nil,
    payload:[String:Any?]? = nil,
    headers:[String:String]? = nil,
    version:String = "1.0",
    hasVersion:Bool = false
   ) {
    
    self.baseUrl = baseUrl
    self.httpMethod = httpMethod
    self.path = path
    self.query = query
    self.payload = payload
    self.headers = headers
    self.version = version
    self.hasVersion = hasVersion
  }
}

extension RequestParameter {
  
  public func asURLRequest() -> URLRequest {
    
    let url = "\(baseUrl)\(hasVersion ? "/v\(version)":"")/\(path)"
    
    var components = URLComponents(string: url)
    if let qItems = query {
      let queryItems:[URLQueryItem] = qItems.reduce([], { (result, current) -> [URLQueryItem] in
        var _result = result
        _result.append(URLQueryItem(name: current.key, value: "\(current.value!)"))
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
#if canImport(UIKit)
public class BoundaryCreater {
    private var data = Data()
    private let boundary = UUID().uuidString
   
   
    public func addEndBoundary()->BoundaryCreater  {
        data.append("\r\n--\(boundary)--\r\n")
        return self
    }
    
    public func addToBoundary(_ dict:[String:String]?, dataBoundary:DataBoundary? = nil)->BoundaryCreater{
       
        
        if let dataBoundary = dataBoundary{
            switch dataBoundary {
            case let .image(key, fileName, image):
                if let imageData = image?.jpegData(compressionQuality: 1) {
                    createBoundaryItem(valueBoundary: .data(imageData, key, fileName))
                }
                
            case let .vdo(key, urlFile):
                if let vdoData = try? Data(contentsOf: urlFile) {
                    let fileName = urlFile.lastPathComponent
                    createBoundaryItem(valueBoundary: .data(vdoData, key, fileName))
                }
                
            }
            
        }
        
        if let dict = dict{
            dict.forEach{
                createBoundaryItem(valueBoundary: .string($0, $1))
            }
        }
        
        return self
    }
    
    private func createBoundaryItem(valueBoundary:ValueBoundary){
        
        
        data.append("\r\n--\(boundary)\r\n")
        
        
        switch valueBoundary {
        case let .data(dataFile, key, fileName):
            data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
            data.append("Content-Type: image/่jpge\r\n\r\n")
            data.append(dataFile)
            
        case let .string(key, value):
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            data.append(value)
        
        }
        
        
    }
    
    public func setRequestMultipart(_ request:inout URLRequest)->Data{
      
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        return data
        
      
    }
    
   
    public enum ValueBoundary {
        case data(_ data:Data, _ key:String, _ fileName:String)
        case string(_ key:String, _ value:String)
    }
    
    public enum DataBoundary{
        case image(_ key:String,_ fileName:String,_ image:UIImage?)
        case vdo(_ key:String,_ urlFile:URL)
    }
}

#endif
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
