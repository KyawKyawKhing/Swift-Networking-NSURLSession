//
//  BaseResponse.swift
//  NewsApp-URLSessionAndCodeable
//
//  Created by Win Than Htike on 11/9/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import Foundation

class BaseResponse: Codable {
    
    var status : String!
    
    var totalResults : Int64!
    
    var articles : [NewsVO] = []
    
}
