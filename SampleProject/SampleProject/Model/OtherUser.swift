//
//  OtherUser.swift
//  AomSook
//
//  Created by Sakon Ratanamalai on 20/6/2562 BE.
//  Copyright © 2562 megazy. All rights reserved.
//

import Foundation

struct OtherUserElement: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias OtherUser = [OtherUserElement]
