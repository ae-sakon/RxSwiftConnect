//
//  Search.swift
//  iOS-Jertam-V6
//
//  Created by iMac-51 on 12/2/2562 BE.
//  Copyright © 2562 Megazy. All rights reserved.
//

import Foundation

struct QuerySearch:Codable {
    let plim:Int
    let pno:Int
    let dist:Int
    let shape:String
    var cord:String
    
    init(plim:Int,pno:Int,lat:Double,lng:Double,dist:Int,shape:String) {
        
        self.plim = plim
        self.pno = pno
        self.dist = dist
        self.shape = shape
        self.cord = "\(lat),\(lng)"
        
    }
    
   
}

struct SearchResult : Codable {
    
    let Status : Bool
    let Data : Data
    
    enum CodingKeys : String,CodingKey {
        case Status = "Status"
        case Data = "Data"
    }
    
    struct Data : Codable {
        
        let totalItem : Int
        var itemData : [ItemData]
        
        enum CodingKeys : String,CodingKey {
            case totalItem = "totalItem"
            case itemData = "itemData"
        }
        
        struct ItemData : Codable {
            
            let name : String
            let category : Int
            let lat : Double
            let lng : Double
            let image : String
            let checkInCount : Int
            let isAR : Int
            let stampID : String
            let webLink : String
            let placeID : Int
            let coin : Int
            let stampImage : String
            let stampImagePath : String
            
            enum CodingKeys : String,CodingKey {
                
                case name = "name"
                case category = "category"
                case lat = "lat"
                case lng = "lng"
                case image = "image"
                case checkInCount = "checkInCount"
                case isAR = "isAR"
                case stampID = "stampID"
                case webLink = "webLink"
                case placeID = "placeID"
                case coin = "coin"
                case stampImage = "stampImage"
                case stampImagePath = "stampImagePath"
                
            }
            
        }
        
    }
    
    
}
