//
//  DetailViewController.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    // contact displayed; just set it to some value at first
    var task : Task = Task(task: "", details: "", deadline: Date.init(), timeBucket: -1, isUrgent: false, isImportant: false)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set features of labels
        nameLabel.text = ("\(task.task)")
        
        detailLabel.text = ("\(task.details)")
        
        // time bucket
        timeLabel.text = ("\(task.timeBucket)")
        switch task.timeBucket {
        case 0:
            timeLabel.text = ("<5 min")
        case 1:
            timeLabel.text = ("30 min")
        case 2:
            timeLabel.text = ("1 hr")
        case 3:
            timeLabel.text = ("2+ hrs")
        default: break
        }
        
        // deadline
        deadlineLabel.text = ("\(task.deadline)")
        
        // urgency
        if task.isUrgent {
            urgencyLabel.text = ("High")
        } else {
            urgencyLabel.text = ("Low")
        }
        
        // importance
        if task.isImportant {
            importanceLabel.text = ("High")
        } else {
            importanceLabel.text = ("Low")
        }

    }


}
