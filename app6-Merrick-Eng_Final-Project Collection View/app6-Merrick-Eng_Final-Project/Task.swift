//
//  Contact.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import Foundation
import UIKit

struct Task : Equatable {
    
    // REQUIRED FIELDS ***********************
    // task
    let task : String
    
    // task details
    let details : String
    
    // deadline
    let deadline : Date
    
    // timeBucket
    // 0 = shortest, 4 = longest
    let timeBucket : Int
    
    // urgent?
    let isUrgent : Bool
    
    // important?
    let isImportant : Bool
}
