//
//  TasksTableViewController.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import UIKit

class TrashViewController: UITableViewController, UITabBarDelegate {

    // array to store all contacts
//    var TaskData.sharedInstance.array = [Task]()
    var currTaskRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - Basic table view methods
    // no changes needed for this one
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // size of row
        return 60.0
    }
    
    // gets number of rows in the section, which is dependent on news array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: How many rows in our section?
        return TaskData.sharedInstance.trash.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: How many sections? (Hint: we have 1 section and x rows)
        return 1
    }
    
    // get the specific cell we are referring to
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        
        // deque with identifier and get cell reference; all cells have same identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "doNowCell")
        
        // current contact referenced
        let currentTask =  TaskData.sharedInstance.trash[indexPath.row]
        
        // set features of cell labels; subtitle cell style provides the reference so no need for tags
        cell?.textLabel?.text = ("\(currentTask.task)")
        cell?.detailTextLabel?.text = ("\(currentTask.details)")
        
        return cell ?? UITableViewCell()
    }
    
    // Create a standard header that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        
        if TaskData.sharedInstance.trash.count == 0 { return "Nothing here! Mark a task a done."}
        if section == 0 { return "Already completed tasks"}
        
        return ""
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(named: "Tan")
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    // MARK: - Handle user interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and pass to DVC
        
        // deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // save current contact position
        currTaskRow = indexPath.row

        // do the actions
        // pass to DVC
        // call segue
        print("Performing Segue Pt 1")
        
        self.performSegue(withIdentifier: "segueToDVC", sender: self)
        print("Performing Segue Pt 2")
        
        // refresh data
        self.tableView.reloadData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
                var row = 0
                if sourceIndexPath.section < proposedDestinationIndexPath.section {
                    row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
                }
                return IndexPath(row: row, section: sourceIndexPath.section)
            }
            return proposedDestinationIndexPath
    }
    
    // prepare for segue; performed any time segue performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Preparing for Segue")
        
        // current contact we're looking at is contact field
        
        // pass data to detail view controller
        if let dvc = segue.destination as? DetailViewController {
            // get contact at specific index path
            dvc.task = TaskData.sharedInstance.trash[currTaskRow]
        }
        
    }
    
    // MARK: - Swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: If the editing style is deletion, remove the newsItem from your model and then delete the rows. CAUTION: make sure you aren't calling tableView.reloadData when you update your model -- calling both tableView.deleteRows and tableView.reloadData will make the app crash.
        
        // remove item from model
        if editingStyle == .delete {
            let currTask = TaskData.sharedInstance.trash[indexPath.row]
            
            // remove from current
            TaskData.sharedInstance.trash.remove(at: indexPath.row)
            
//            // remove from database
//            TaskData.sharedInstance.array.removeAll {$0 == currTask}
            
            TaskData.sharedInstance.array.append(currTask)
            
            // remove from view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // change name to done
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Add back"
    }
    
    // change color to green
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Add back") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(named: "Forest Green")
        return [deleteButton]
    }
}
