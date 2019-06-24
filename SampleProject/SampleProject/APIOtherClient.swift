//
//  APIOtherClient.swift
//  AppStarterKit
//
//  Created by Sakon Ratanamalai on 20/6/2562 BE.
//  Copyright © 2562 Sakon Ratanamalai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftConnect

class APIOtherClient {
    
    public static var shared = APIOtherClient()
    private let requester:Requester
    typealias E = CustomError;typealias O = Observable;typealias R = Result
    
    private init() {
        let beseUrl = "https://jsonplaceholder.typicode.com"
      requester = Requester(initBaseUrl: beseUrl,timeout: 5, isPreventPinning: false, initSessionConfig: URLSessionConfiguration.default)
    }
    
    func getOtherUser() -> O<R<OtherUser,E>> {
        return requester.get(path: "posts")
    }
}


