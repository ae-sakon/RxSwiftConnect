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
    
    public init(initBaseUrl:String,timeout:Int,isPreventPinning:Bool,initSessionConfig:URLSessionConfiguration){
        self.baseUrl = initBaseUrl
        //self.requester = initRequester
        self.preventPinning = isPreventPinning
        self.sessionConfig = initSessionConfig
        self.sessionConfig.timeoutIntervalForRequest = TimeInterval(timeout)
    }
    
    public func post<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,header:[String:String]? = nil,loading:Bool = true) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .post,
            path: path,
            baseUrl: self.baseUrl,
            payload: sendParameter?.dictionaryValue ?? nil,
            headers: header).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig,isPreventPinning: preventPinning)
        
    }
    public func get<DataResult:Decodable, CustomError:DecodError>(path:String,sendParameter:Encodable? = nil,loading:Bool = true) -> Observable<Result<DataResult, CustomError>>{
        
        setupLoading(isShow: loading)
        
        let requestParameter = RequestParameter(
            httpMethod: .get,
            path: path,
            baseUrl: self.baseUrl,
            payload: sendParameter?.dictionaryValue ?? nil,
            headers: nil).asURLRequest()
        
        return  self.call(requestParameter,config: sessionConfig, isPreventPinning: preventPinning)
        
    }
    
    public func getRaw<CustomError:DecodError>(path:String,loading:Bool = true) -> Observable<Result<RawResponse, CustomError>>{
        setupLoading(isShow: loading)
        var requestParameter = RequestParameter(
            httpMethod: .get,
            path: path,
            baseUrl: self.baseUrl,
            payload:  nil,
            headers: nil).asURLRequest()
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
                let task = urlSession.dataTask(with: request) { data, response, error in
                    
                    if error != nil {
                        _self.hideLoading()
                        let customError = CustomError(error: error!)
                        observer.onNext(Result.failure(customError))
                    }else{
                        _self.hideLoading()
                        if let httpResponse = response as? HTTPURLResponse{
                            let statusCode = httpResponse.statusCode
                            
                            do {
                                let _data = data ?? Data()
                                if statusCode == 200 {
                                    let objs = try _self.decoder.decode(DataResult.self, from: _data)
                                    observer.onNext(Result.successful(objs))
                                } else {
                                    let customError = CustomError(responseCode: httpResponse.statusCode)
                                    observer.onNext(Result.failure(customError))
                                }
                            } catch {
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
                
                topView.view.viewWithTag(101)?.removeFromSuperview()
                
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


