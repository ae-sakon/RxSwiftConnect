//
//  RequestCaller.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation
import RxSwift
import RxCocoa

public typealias DecodError = Decodable & ErrorInfo

public class Requester:NSObject{
    
    private let baseUrl:String
    private lazy var decoder = JSONDecoder()
    private let sessionConfig:URLSessionConfiguration
    private let preventPinning:Bool
    private let hasVersion:Bool
    
    public init(initBaseUrl:String, timeout:Int, isPreventPinning:Bool, initSessionConfig:URLSessionConfiguration, hasVersion:Bool = false){
        self.baseUrl = initBaseUrl
        //self.requester = initRequester
        self.preventPinning = isPreventPinning
        self.sessionConfig = initSessionConfig
        self.sessionConfig.timeoutIntervalForRequest = TimeInterval(timeout)
        self.hasVersion = hasVersion
    }
    
    public func postQuery<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,header:[String:String]? = nil,loading:Bool = true) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .post,
            path: path,
            baseUrl: self.baseUrl,
            query: sendParameter?.dictionaryValue ?? nil,
            headers: header,
            hasVersion: hasVersion).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig,isPreventPinning: preventPinning)
        
    }
    
    public func post<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,header:[String:String]? = nil,loading:Bool = true) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .post,
            path: path,
            baseUrl: self.baseUrl,
            payload: sendParameter?.dictionaryValue ?? nil,
            headers: header,
            hasVersion: hasVersion).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig,isPreventPinning: preventPinning)
        
    }
    
    public func post<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,header:[String:String]? = nil, loading:Bool = true, version:String) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .post,
            path: path,
            baseUrl: self.baseUrl,
            payload: sendParameter?.dictionaryValue ?? nil,
            headers: header,
            version: version,
            hasVersion: hasVersion).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig,isPreventPinning: preventPinning)
        
    }
    
    public func postBoundary<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,loading:Bool = true, header:[String:String]? = nil, dataBoundary:BoundaryCreater.DataBoundary? = nil) -> Observable<Result<DataResult, CustomError>>{
        
        let boundaryCreater = BoundaryCreater()
        
        var requestParameter = RequestParameter(
            httpMethod: .post,
            path: path,
            baseUrl: self.baseUrl,
            payload: nil,
            headers: header,
            hasVersion: hasVersion).asURLRequest()
        
        let data = boundaryCreater
            .addToBoundary(sendParameter?.dictionaryStringValue, dataBoundary: dataBoundary)
            .addEndBoundary()
            .setRequestMultipart(&requestParameter)
        
        return  self.callUpload(requestParameter,config: sessionConfig,isPreventPinning: preventPinning, dataUploadTask : data)
    }
    
    public func get<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,loading:Bool = true) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .get,
            path: path,
            baseUrl: self.baseUrl,
            query: sendParameter?.dictionaryValue ?? nil,
            headers: nil,
            hasVersion: hasVersion).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig, isPreventPinning: preventPinning)
        
    }
    
    public func getRaw<CustomError:DecodError>(path:String,loading:Bool = true) -> Observable<Result<RawResponse, CustomError>>{
        setupLoading(isShow: loading)
        var requestParameter = RequestParameter(
            httpMethod: .get,
            path: path,
            baseUrl: self.baseUrl,
            payload:  nil,
            headers: nil,
            hasVersion: hasVersion).asURLRequest()
        requestParameter.url = URL(string: path)
        
        return  self.call(requestParameter,config: sessionConfig,isPreventPinning: preventPinning)
        
    }
    
    func setupLoading(isShow:Bool){
        DispatchQueue.main.async {
            if isShow, let topView = UIApplication.topViewController(){
                Loading.shared.show(viewController: topView)
            }
        }
    }
    
    
    func call<DataResult:Decodable, CustomError:DecodError>(_ request: URLRequest, config:URLSessionConfiguration,isPreventPinning:Bool)
        -> Observable<Result<DataResult, CustomError>> {
            
            return Observable.create { [weak self] observer in
                
                guard let _self = self else { return Disposables.create{self?.hideLoading()} }
                
                let sessionPinning = SessionPinningDelegate(statusPreventPinning: isPreventPinning);
                let urlSession = URLSession(configuration: config, delegate: sessionPinning, delegateQueue: nil)
                let task = urlSession.dataTask(with: request) {
                    _self.processResult($0, $1, $2, observer: observer, request: request)
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                    _self.hideLoading()
                }
            }
    }
    
    
    func call<CustomError:DecodError>(_ request: URLRequest, config:URLSessionConfiguration,isPreventPinning:Bool)
        -> Observable<Result<RawResponse, CustomError>> {
            
            return Observable.create { [weak self] observer in
                
                guard let _self = self else { return Disposables.create{self?.hideLoading()} }
                
                let sessionPinning = SessionPinningDelegate(statusPreventPinning: isPreventPinning);
                let urlSession = URLSession(configuration: config, delegate: sessionPinning, delegateQueue: nil)
                let task = urlSession.dataTask(with: request) { data, response, error in
                    
                    if error != nil {
                        let customError = CustomError(error: error!)
                        observer.onNext(Result.failure(customError))
                    }else{
                        self!.hideLoading()
                        if let httpResponse = response as? HTTPURLResponse{
                            let statusCode = httpResponse.statusCode
                            
                            let _data = data ?? Data()
                            if statusCode == 200 {
                                let plainResponse = RawResponse(statusCode: statusCode, data: _data)
                                observer.onNext(Result.successful(plainResponse))
                            } else {
                                let customError = CustomError(responseCode: httpResponse.statusCode)
                                observer.onNext(Result.failure(customError))
                            }
                            
                        }else{
                            let customError = CustomError(unknowError: "Error URLSession")
                            observer.onNext(Result.failure(customError))
                        }
                    }
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                    _self.hideLoading()
                }
            }
    }
    
    
    func hideLoading(){
        DispatchQueue.main.async {
            if let topView = UIApplication.topViewController(){
                Loading.shared.hide(viewController: topView)
            }
        }
    }
}
extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    func encodeJson() -> String {
        
        do{
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        catch{
            print("error encode \(self) to JSON ")
            return ""
        }
    }
    
    var dictionaryValue:[String: Any?]? {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return nil
        }
        return dictionary
    }
    
    var dictionaryStringValue:[String: String]? {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return nil
        }
       
       
        var dic:[String:Any] = [:]
        dictionary.forEach{
            dic.append(anotherDict: [$0.key:"\($0.value)"])
        }
     
        return dic as? [String:String]
    }
    
    
}

extension Dictionary where Key == String, Value == Any {

    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
}


extension Requester{
    
    private func processResult<DataResult:Decodable, CustomError:DecodError>(_ data:Data?,
                                                                             _ response:URLResponse?,
                                                                             _ error:Error?,
                                                                             observer: AnyObserver<Result<DataResult, CustomError>>,
                                                                             request:URLRequest) {
        var token = "empty"
        
        do{
            
            token = try request.allHTTPHeaderFields?.tryValue(forKey: "Authorize") ?? ""
        }catch{
            
        }
        
        if error != nil {
            hideLoading()
            let customError = CustomError(error: error!)
            observer.onNext(Result.failure(customError))
        }else{
            hideLoading()
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                
                do {
                    let _data = data ?? Data()
                    if statusCode == 200 {
                        let objs = try decoder.decode(DataResult.self, from: _data)
                        observer.onNext(Result.successful(objs))
                    } else {
                        var customError = CustomError(responseCode: httpResponse.statusCode)
                       
                        
                        
                        customError.errorInfo = "service \(httpResponse.url?.absoluteString ?? "") error \(httpResponse.statusCode) | token : \(token) | ==> \(String(data: _data, encoding: .utf8) ?? "")"
                        observer.onNext(Result.failure(customError))
                    }
                } catch {
                    var customError = CustomError(responseCode: httpResponse.statusCode)
                    customError.errorInfo = "service \(httpResponse.url?.absoluteString ?? "") error typeMismatch | token : \(token) | ==> \(error)"
                    observer.onNext(Result.failure(customError))
                }
            }else{
                let customError = CustomError(unknowError: "Error URLSession")
                observer.onNext(Result.failure(customError))
            }
        }
    }
    func callUpload<DataResult:Decodable, CustomError:DecodError>(_ request: URLRequest, config:URLSessionConfiguration,isPreventPinning:Bool, dataUploadTask:Data?)
        -> Observable<Result<DataResult, CustomError>> {
            
            return Observable.create { [weak self] observer in
                
                guard let _self = self else { return Disposables.create{self?.hideLoading()} }
                
                let sessionPinning = SessionPinningDelegate(statusPreventPinning: isPreventPinning);
                let urlSession = URLSession(configuration: config, delegate: sessionPinning, delegateQueue: nil)
                let task = urlSession.uploadTask(with: request, from:dataUploadTask) {
                    _self.processResult($0, $1, $2, observer: observer, request: request)
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                    _self.hideLoading()
                }
            }
    }
}



public struct DictionaryTryValueError: Error {
    public init() {}
}

public extension Dictionary {
    func tryValue(forKey key: Key, error: Error = DictionaryTryValueError()) throws -> Value {
        guard let value = self[key] else { throw error }
        return value
    }
    
}
