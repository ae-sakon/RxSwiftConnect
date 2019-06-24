//
//  APIClient.swift
//  AppStarterKit
//
//  Created by Sakon Ratanamalai on 20/6/2562 BE.
//  Copyright © 2562 Sakon Ratanamalai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftConnect

class APIClient {
    
    public static var shared = APIClient()
    private let requester:Requester
    typealias E = CustomError;typealias O = Observable;typealias R = Result
    
    private func setHeader(_ token:String = "")->[String:String]?{
        let s  = Bundle.main.bundleIdentifier!
        return token.count == 0 ? ["Signature":s] : ["Signature":s,"Authorize": token]
    }
    
    private init() {
        let beseUrl = "https://webstarter.megazy.com"
        requester = Requester(initBaseUrl: beseUrl,timeout: 5, isPreventPinning: false, initSessionConfig: URLSessionConfiguration.default)
    }
    
    func getNearby(postData:PostPlace) -> Observable<Result<Place, E>>{
        return requester.post(path: "place/getnearby", sendParameter: postData,header: setHeader(),loading: false)
    }

    
    

    
    
}

