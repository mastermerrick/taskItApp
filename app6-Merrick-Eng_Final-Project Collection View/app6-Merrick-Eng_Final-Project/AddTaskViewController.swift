//
//  AddTaskViewController.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import UIKit

/**
 Create class protocol, which establishes a weak connection ensuring no reference cycle.
 */
protocol AddTaskDelegate: class {
    // function that must be implemented by the view controller adopting this protocol
    func didCreate(_ contact: Task)
}

class AddTaskViewController: UIViewController {
    

    // Add delegate variable
    weak var delegate: AddTaskDelegate?
   
    // Picker
    var pickerData: [[String]]=[[String]]()
    
    // text fields
    @IBOutlet weak var text_task: UITextField!
    @IBOutlet weak var text_detail: UITextField!
    
    // deadline
    @IBOutlet weak var text_deadline: UIDatePicker!
    
    // required time; time bucket
    @IBOutlet weak var text_timeBucket: UISegmentedControl!
    
    // buttons
    @IBOutlet weak var urgAndImportant: RadioButton!
    @IBOutlet weak var notUrgAndImportant: RadioButton!
    @IBOutlet weak var urgAndNotImportant: RadioButton!
    @IBOutlet weak var notUrgAndNotImportant: RadioButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Name segments
        text_timeBucket.setTitle("<5 min", forSegmentAt: 0)
        text_timeBucket.setTitle("30 min", forSegmentAt: 1)
        text_timeBucket.setTitle("1 hr", forSegmentAt: 2)
        text_timeBucket.setTitle("2+ hrs", forSegmentAt: 3)
        
        // create radio button groups
        urgAndImportant?.alternateButton = [notUrgAndImportant, urgAndNotImportant, notUrgAndNotImportant]
        notUrgAndImportant?.alternateButton = [urgAndImportant, urgAndNotImportant, notUrgAndNotImportant]
        urgAndNotImportant?.alternateButton = [urgAndImportant, notUrgAndImportant, notUrgAndNotImportant]
        notUrgAndNotImportant?.alternateButton = [urgAndImportant, notUrgAndImportant, urgAndNotImportant]
    }
    

    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // function to create contact
    func createNewTask() -> Task? {
        // check fields are not null first
        if (text_task.text == "") {
            return nil;
        }
        
        // access IBOutlets of text fields to create new contact
        let task = Task(task: text_task.text!, details: text_detail.text!, deadline: text_deadline.date, timeBucket: text_timeBucket.selectedSegmentIndex, isUrgent: isUrgent(), isImportant: isImportant())
        
        return task
    }
    
    // function to save contact
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        
        // create new contact by accessing fields
        let newTask = createNewTask()
        
        // check that createNewContact is not nil
        if let task = newTask {
            // call didCreate on the class implementing protocol
            // this will save the data to its own class
            self.delegate?.didCreate(task)
        }
        
        
         dump(newTask)
        
         //dismiss controller
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Radio Buttons
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
            
        urgAndImportant.isSelected = false
        notUrgAndImportant.isSelected = false
        urgAndNotImportant.isSelected = false
        notUrgAndNotImportant.isSelected = true
    }
    
    
    // helper function to check if button is urgent
    func isUrgent() -> Bool {
        if urgAndImportant.isSelected || urgAndNotImportant.isSelected {
            return true
        }
        
        return false
    }
    
    // helper function to check if button is urgent
    func isImportant() -> Bool {
        if urgAndImportant.isSelected || notUrgAndImportant.isSelected {
            return true
        }
        
        return false
    }
    
    
    @IBAction func showInfo(_ sender: Any) {
        // UIAlertController with text field, cancel button, done button
        print("instructions showing");
        
        // no text, tell user to put text
        let infoMessage = UIAlertController(title: "Add a task", message: nil, preferredStyle: .alert)
        
        let alertMessage = """
        Add a task by filling out the appropriate information.
        
        Urgent indicates how soon the task must be completed. Important represents how critical the task is for your personal gain.
        """
        
        // align left
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            
            let attributedMessageText = NSMutableAttributedString(
                string: alertMessage,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                ]
            )
        
        infoMessage.setValue(attributedMessageText, forKey: "attributedMessage")
        
        // ok button
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code triggers when done button pressed
            print("Ok tapped");
        }
        
        infoMessage.view.tintColor = UIColor.init(named: "Forest Green")
        
        infoMessage.addAction(okayAction)
        present(infoMessage, animated: true)
    }
}
