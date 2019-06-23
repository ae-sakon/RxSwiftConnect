//
//  SessionPinningDelegate.swift
//  RxSwiftConnect
//
//  Created by Sakon Ratanamalai on 2019/05/05.
//

import Foundation

public class SessionPinningDelegate: NSObject, URLSessionDelegate{
    
    private var preventPinning : Bool = false
    public init(statusPreventPinning:Bool){
        preventPinning = statusPreventPinning
    }
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        if(preventPinning){
            //Adapted from OWASP https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning#iOS
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    var secresult = SecTrustResultType.invalid
                    let status = SecTrustEvaluate(serverTrust, &secresult)
                    
                    if(errSecSuccess == status) {
                        if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                            let serverCertificateData = SecCertificateCopyData(serverCertificate)
                            let data = CFDataGetBytePtr(serverCertificateData);
                            let size = CFDataGetLength(serverCertificateData);
                            let cert1 = NSData(bytes: data, length: size)
                            let file_cer = Bundle.main.path(forResource: "certificate", ofType: "cer")
                            
                            if let file = file_cer {
                                if let cert2 = NSData(contentsOfFile: file) {
                                    if cert1.isEqual(to: cert2 as Data) {
                                        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
        else
        {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling,nil)
            return
        }
    }
    
}
