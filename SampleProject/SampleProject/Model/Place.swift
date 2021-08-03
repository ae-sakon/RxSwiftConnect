//
//  PlaceInfoResult.swift
//  AppStarterKit
//
//  Created by khuad on 9/6/2562 BE.
//  Copyright © 2562 megazy. All rights reserved.
//

import Foundation
// MARK: - PlaceInfoResult
struct Place: Codable {
    let result: [PlaceInfo]?
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - PlaceInfo
struct PlaceInfo: Codable {
    let categoryID, checkinCount, coin: Int
    let distance: Double
    let image: String?
    let isAR: Bool
    let lastCheckIn: String?
    let lat, lng: Double
    let name: String?
    let placeID, rowNo: Int
    let stampID, stampImage, stampImagePath, webLink: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "CategoryID"
        case checkinCount = "CheckinCount"
        case coin = "Coin"
        case distance = "Distance"
        case image = "Image"
        case isAR = "IsAR"
        case lastCheckIn = "LastCheckIn"
        case lat = "Lat"
        case lng = "Lng"
        case name = "Name"
        case placeID = "PlaceID"
        case rowNo = "RowNo"
        case stampID = "StampID"
        case stampImage = "StampImage"
        case stampImagePath = "StampImagePath"
        case webLink = "WebLink"
    }
}


struct PostPlace:Codable {
    var lat:Double
    var lng:Double
    let rowPerPage:Int
    var pageNumber:Int
    
    enum CodingKeys:String,CodingKey {
        case rowPerPage = "rowperpage"
        case pageNumber = "pagenumber"
        case lat,lng
    }
}


