//
//  SharedTaskData.swift
//  app6-Merrick-Eng_Final-Project
//
//  Created by Merrick Eng on 4/23/21.
//

import Foundation

class TaskData {
    static let sharedInstance = TaskData()
    var array = [Task]()
    var trash = [Task]()
}
