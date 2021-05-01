//
//  TasksTableViewController.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import UIKit

class TasksTableViewController: UITableViewController, AddTaskDelegate, UITabBarDelegate {

    // array to store all contacts
//    var TaskData.sharedInstance.array = [Task]()
    var currContactPosition = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // add first task
        TaskData.sharedInstance.array.append(Task(task: "Finish up my app", details: "add radio buttons", deadline: Date.init(), timeBucket: 2, isUrgent: true, isImportant: true))
        
        // add second task
        TaskData.sharedInstance.array.append(Task(task: "Submit receipts", details: "Get reimbursed", deadline: Date.init(), timeBucket: 0, isUrgent: true, isImportant: false))
        
        // add third task
        TaskData.sharedInstance.array.append(Task(task: "Get my haircut", details: "Anna is available until 7pm", deadline: Date.init(), timeBucket: 2, isUrgent: false, isImportant: true))
        
        // add 4th task
        TaskData.sharedInstance.array.append(Task(task: "Look into getting a hedgehog", details: "", deadline: Date.init(), timeBucket: 1, isUrgent: false, isImportant: false))
        
        // add 5th task
        TaskData.sharedInstance.array.append(Task(task: "Send email to Michael", details: "Order paint by the numbers", deadline: Date.init(), timeBucket: 0, isUrgent: true, isImportant: true))
        
        // add 6th task
        TaskData.sharedInstance.array.append(Task(task: "Look into housing situation", details: "Look at apartments in East Village", deadline: Date.init(), timeBucket: 0, isUrgent: false, isImportant: true))

        
        // refresh data
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    /*
     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
     Get the new view controller using segue.destination.
    
     /Users/merrick/Documents/2020-2021 Spring Semester/CIS 195 iOS/apps/app6-Merrick-Eng_Final-Project/app6-Merrick-Eng_Final-Project/TasksTableViewController.swift     Pass th6e selected object to the new view controller.
    }
    */

    @IBAction func goToACVC(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToATVC", sender: self)
    }
    
    // MARK: - Basic table view methods
    // no changes needed for this one
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // size of row
        return 60.0
    }
    
    // gets number of rows in the section, which is dependent on news array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: How many rows in our section?
        return TaskData.sharedInstance.array.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: How many sections? (Hint: we have 1 section and x rows)
        return 1
    }
    
    // get the specific cell we are referring to
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        
        // deque with identifier and get cell reference; all cells have same identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")
        
        // current contact referenced
        let currentTask = TaskData.sharedInstance.array[indexPath.row]
        
        // set features of cell labels; subtitle cell style provides the reference so no need for tags
        cell?.textLabel?.text = ("\(currentTask.task)")
        cell?.detailTextLabel?.text = ("\(currentTask.details)")
        
        return cell ?? UITableViewCell()
    }
    
    
    // MARK: - Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and pass to DVC
        
        // deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // save current contact position
        currContactPosition = indexPath.row

        // do the actions
        // pass to DVC
        // call segue
        print("Performing Segue Pt 1")
        self.performSegue(withIdentifier: "segueToDVC", sender: self)
        print("Performing Segue Pt 2")
        
        // refresh data
        self.tableView.reloadData()
        
        
    }
    
    // prepare for segue; performed any time segue performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepraing for Segue")
        // current contact we're looking at is contact field
        
        // pass data to detail view controller
        if let dvc = segue.destination as? DetailViewController {
            // get contact at specific index path
            dvc.task = TaskData.sharedInstance.array[currContactPosition]
        }
        
        // pass data to add task controller
        if let navc = segue.destination as? UINavigationController {
            // get acvc
            let atvc = navc.topViewController as? AddTaskViewController
            
            // get contact at specific index path
            atvc!.delegate = self
        }
        
        // pass data to to do list view controller
        if let navc = segue.destination as? UINavigationController {
            // get acvc
            let acvc = navc.topViewController as? AddTaskViewController
            
            // get contact at specific index path
            acvc!.delegate = self
        }
        
    }
    
    // MARK: - Swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: If the editing style is deletion, remove the newsItem from your model and then delete the rows. CAUTION: make sure you aren't calling tableView.reloadData when you update your model -- calling both tableView.deleteRows and tableView.reloadData will make the app crash.
        
        // remove item from model
        if editingStyle == .delete {
            TaskData.sharedInstance.array.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Add protocol conformance
    // append contact from the delegate class
    func didCreate(_ contact: Task) {
        // dismiss ACVC controller
        dismiss(animated: true, completion: nil)
        
        // add new contact to contacts array
        TaskData.sharedInstance.array.append(contact)
        
        // reload table view; refresh data
        self.tableView.reloadData()
    }

    
    @IBAction func showInfo(_ sender: Any) {
        // UIAlertController with text field, cancel button, done button
        print("instructions showing");
        
        // no text, tell user to put text
        let infoMessage = UIAlertController(title: "All Tasks", message: "All your tasks will show up here. Add your tasks by clicking the \"+\" icon.", preferredStyle: .alert)
        
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
