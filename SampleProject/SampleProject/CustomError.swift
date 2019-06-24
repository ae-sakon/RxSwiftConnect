//
//  CustomError.swift
//  AppStarterKit
//
//  Created by Sakon Ratanamalai on 20/6/2562 BE.
//

import Foundation
import RxSwiftConnect

class CustomError:ErrorInfo, Codable {
    
    var errorCode: String?
    var errorFriendlyEn:String?
    var errorFriendlyTh:String?
    var errorInfo:String?
    
    required init(error:Error){
        self.errorInfo = error.localizedDescription
        let errorFromClient = (inputError: error, verion: "" )
        switch errorFromClient {
            
        case (let inputError, _) where (inputError.localizedDescription.contains("The Internet connection appears to be offline")) :
            self.errorCode = String(-1009)
            self.errorFriendlyEn = "The Internet connection appears to be offline."
            self.errorFriendlyTh = "ไม่สามารถติดต่ออินเทอร์เน็ตได้"
        case (let inputError, _) where (inputError.localizedDescription.contains("The request timed out")) :
            self.errorCode = String(-1001)
            self.errorFriendlyEn = "The request timed out."
            self.errorFriendlyTh = "แอปตัดการเชื่อมต่อไปยังระบบ"
        case ( _,_) :
            self.errorCode = String("Unexpected error check ErrorCode from .errorInfo")
            self.errorFriendlyEn = "Error Connection App and Host."
            self.errorFriendlyTh = "เกิดปัญหาการเชื่อมต่อระหว่างแอปและระบบ"
        }
    }
    required init(responseCode:Int){
        self.errorInfo = "https://en.wikipedia.org/wiki/List_of_HTTP_status_codes"
        let errorFromHost = (inputResponseCode: responseCode, verion: "")
        switch errorFromHost {
            
        case (let inputResponseCode, _) where (inputResponseCode == 500) :
            self.errorCode = String(inputResponseCode)
            self.errorFriendlyEn = "Internal Server Error"
            self.errorFriendlyTh = "ระบบขัดข้อง"
        case (let inputResponseCode, _) where (inputResponseCode == 404) :
            self.errorCode = String(inputResponseCode)
            self.errorFriendlyEn = "Not Found"
            self.errorFriendlyTh = "ไม่พบระบบเซอร์วิสให้บริการ"
        case (let inputResponseCode, _) where (inputResponseCode == 403) :
            self.errorCode = String(inputResponseCode)
            self.errorFriendlyEn = "Forbidden"
            self.errorFriendlyTh = "ไม่มีสิทธิ์เข้าใช้งานระบบเซอร์วิส"
        case (let inputResponseCode, _) :
            self.errorCode = String(inputResponseCode)
            self.errorFriendlyEn = "Server Error"
            self.errorFriendlyTh = "ระบบไม่สามารถให้บริการได้"
        }
    }
    required init(unknowError:String){
        self.errorInfo = unknowError
        self.errorCode = "-0"
        self.errorFriendlyEn = "Application Error"
        self.errorFriendlyTh = "แอปไม่สามารถใช้งานได้"
        
    }
    
}
