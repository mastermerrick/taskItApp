//
//  TasksTableViewController.swift
//  app4-Merrick-Eng
//
//  Created by Merrick Eng on 3/2/21.
//

import UIKit

class ToDoListViewController: UITableViewController, AddTaskDelegate, UITabBarDelegate {

    // array to store all contacts
//    var TaskData.sharedInstance.array = [Task]()
    var currTaskRow = 0
    var currTaskSection = 0
    var taskBuckets = [[Task]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortDataForView()
        

        // Do any additional setup after loading the view.
        
        // refresh data
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sortDataForView()
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
        self.performSegue(withIdentifier: "segueToACVC", sender: self)
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
        return taskBuckets[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: How many sections? (Hint: we have 1 section and x rows)
        return 4
    }
    
    // get the specific cell we are referring to
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        
        // deque with identifier and get cell reference; all cells have same identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "doNowCell")
        
        // current contact referenced
        let currentTask = taskBuckets[indexPath.section][indexPath.row]
        
        // set features of cell labels; subtitle cell style provides the reference so no need for tags
        cell?.textLabel?.text = ("\(formatTitle(title: currentTask.task))")
        cell?.detailTextLabel?.text = ("\(currentTask.details)")
        
        // set features of label
        if let timeLabel = cell?.viewWithTag(3) as? UILabel {
            // set label as item title
            switch currentTask.timeBucket {
            case 0:
                timeLabel.text = ("<5 MIN")
            case 1:
                timeLabel.text = ("30 MIN")
            case 2:
                timeLabel.text = ("1 HR")
            case 3:
                timeLabel.text = ("2+ HRS")
            default: break
            }
            
        }
        
        
        
        return cell ?? UITableViewCell()
    }
    
    // Create a standard header that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        
        
        if section == 0 { return "Do Now"}
        if section == 1 { return "Decide"}
        if section == 2 { return "Delegate"}
        if section == 3 { return "Delete"}
        
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
        currTaskSection = indexPath.section
        currTaskRow = indexPath.row

        // do the actions
        // pass to DVC
        // call segue
        print("Performing Segue Pt 1")
        
        self.performSegue(withIdentifier: "segueToDetailVC", sender: self)
        print("Performing Segue Pt 2")
        
        // refresh data
        self.tableView.reloadData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        // Do not allow any movement between section
//        if ( sourceIndexPath.section != proposedDestinationIndexPath.section) {
//            return sourceIndexPath;
//        }
        // You can even control the movement of specific row within a section. e.g last row in a     Section

        // Check if we have selected the last row in section
//        if (   sourceIndexPath.row < sourceIndexPath.count) {
//            return proposedDestinationIndexPath;
//        } else {
//            return sourceIndexPath;
//        }
        // You can use this approach to implement any type of movement you desire between sections or within section
        
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
            dvc.task = taskBuckets[currTaskSection][currTaskRow]
        }

        
    }
    
    // MARK: - Swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: If the editing style is deletion, remove the newsItem from your model and then delete the rows. CAUTION: make sure you aren't calling tableView.reloadData when you update your model -- calling both tableView.deleteRows and tableView.reloadData will make the app crash.
        
        // remove item from model
        if editingStyle == .delete {
            let currTask = taskBuckets[indexPath.section][indexPath.row]
            
            // remove from current
            taskBuckets[indexPath.section].remove(at: indexPath.row)
            
            // remove from database
            TaskData.sharedInstance.array.removeAll {$0 == currTask}
            
            TaskData.sharedInstance.trash.append(currTask)
            
            // remove from view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // change name to done
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Done"
    }
    
    // change color to green
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Done") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(named: "Forest Green")
        return [deleteButton]
    }


    // MARK: - Add protocol conformance
    // append contact from the delegate class
    func didCreate(_ contact: Task) {
        // dismiss ACVC controller
        dismiss(animated: true, completion: nil)
        
        // add new contact to contacts array
        TaskData.sharedInstance.array.append(contact)
        
//        // sort array alphabetically by last name >> change later based on algoirthm
//        tasks.sort(by: { $0.task.uppercased() < $1.task.uppercased()})
        
        // reload table view; refresh data
        self.tableView.reloadData()
    }

    
    // MARK: - Sorting
    
    // returns bucket
    func sortDataForView() {
        //var buckets = [[Task]]()
        let tasks = TaskData.sharedInstance.array
        
        var doNow = [Task]()
        var decide = [Task]()
        var delegate = [Task]()
        var delete = [Task]()
        
        
        // sort based on matrix
        tasks.forEach({task in
            if task.isUrgent && task.isImportant {doNow.append(task)}
            if !task.isUrgent && task.isImportant {decide.append(task)}
            if task.isUrgent && !task.isImportant {delegate.append(task)}
            if !task.isUrgent && !task.isImportant {delete.append(task)}
            
        })
        
        // DO NOW:
        // sort based on deadline
        doNow.sort(by: { $0.deadline < $1.deadline})
        
        // sort based on time required at the top
        doNow.sort(by: { $0.timeBucket < $1.timeBucket})
        
        
        // DECIDE:
        // sort based on time required first
        decide.sort(by: { $0.timeBucket < $1.timeBucket})
        
        // sort based on deadline bc most important if not doing it now
        decide.sort(by: { $0.deadline < $1.deadline})
        
        // DELEGATE:
        // sort based on time required first
        delegate.sort(by: { $0.timeBucket < $1.timeBucket})
        
        // sort based on deadline bc most important if not doing it now
        delegate.sort(by: { $0.deadline < $1.deadline})
        
        
        // DELETE:
        // sort based on time required first
        delete.sort(by: { $0.timeBucket < $1.timeBucket})
        
        // sort based on deadline bc most important if not doing it now
        delete.sort(by: { $0.deadline < $1.deadline})

        taskBuckets =  [doNow, decide, delegate, delete]
    }
    
//    @IBAction func refreshData(_ sender: Any) {
//        sortDataForView()
//        self.tableView.reloadData()
//    }
    
    @IBAction func showTrash(_ sender: Any) {
        print(TaskData.sharedInstance.trash)
    }

    
    
    @IBAction func showInfo(_ sender: Any) {
        // UIAlertController with text field, cancel button, done button
        print("instructions showing");
        
        // no text, tell user to put text
        let infoMessage = UIAlertController(title: "Your To Do List", message: nil, preferredStyle: .alert)
        
        let alertMessage = """
        All the tasks you added before are here and now sorted.
        \nMark a task as done by swiping to the left on a task.
        \nCheck task details by tapping on it.\n\nTasks are grouped using the Eisenhower Matrix - primarily based on urgency and importance. They are then considered in order of time required and deadline depending on the bucket.
        \nDo now are tasks you should do immediately (urgent and important). Decide are tasks you should decide/schedule when to do them (important to you, but not urgent). Delegate are tasks that you should delegate to someone else (not important but urgent). Delete are tasks you should not do at all (not important or urgent). These are listed here for reference.
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
    
    // helper to format title
    func formatTitle(title: String) -> String {
        var truncatedTitle = ""
        
        let charLimit = 33
        
        guard title.count > charLimit else {
            return title
        }

        for i in (0...charLimit) {
            let char = title[i]
            truncatedTitle += String(char)
        }
        
        return (truncatedTitle + "...")
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
