//
//  ViewController.swift
//  CoreList
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var taskTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var formatter = NSDateFormatter()
    
    var nameString:String = ""
    
    var tasksArray = [NSManagedObject]()
    
    var searchResults = [NSManagedObject]()
    
    var moc = DataController().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM/d/yyyy hh:mm:ss"
        self.fetchTasks()
        self.taskTableView.addSubview(self.refreshControl)
        resetSearchArray()
    }
    
    @IBAction func addTask(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add", message: "Add a task", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (alertAction) -> Void in
            if let textField = alertController.textFields?.first, let text = textField.text {
                self.saveTask(text)
                self.resetSearchArray()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            if let name = textField.text {
                self.nameString = name
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func fetchTasks() {
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let fetchResults = try self.moc.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                
                self.tasksArray = fetchResults
                self.resetSearchArray()
            }
        } catch {
            
        }
    }
    
    func saveTask(name: String) {
        
        if let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.moc) {
            let task = NSManagedObject(entity: taskEntity, insertIntoManagedObjectContext: self.moc)
            let date = NSDate()
            task.setValue(name, forKey: "name")
            task.setValue(date, forKey: "created")
            task.setValue(false, forKey: "isCompleted")
            let theDate = formatter.stringFromDate(date)
            print("\n\n\n\n\n\(theDate)\n\n\n\n\n")
            
            do {
                
                try self.moc.save()
                print("I saved the task: \(task)")
                
                self.tasksArray.append(task)
                self.resetSearchArray()
                
            } catch {
                
                print("I didn't save the task")
                
            }
        }
        
    }
    
    //MARK: -Search Bar Delegate Methods
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBar cancel")
        self.restoreSearchBar("")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("search bar end editing")
        self.resetSearchArray()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchResults.removeAll()
        
        for task in tasksArray {
            // if the city starts with the letter "searchText" then put it in the results array
            if let taskName = task.valueForKey("name") as? String {
                if self.containsString(taskName, searchText: searchText) {
                    self.searchResults.append(task)
                }
            }
        }
        
        self.restoreSearchBar(searchText)
        self.taskTableView.reloadData()
    }
    
    //MARK: -Table View Delegate Methods
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let itemToDelete = tasksArray[indexPath.row]
            
            moc.deleteObject(itemToDelete)
            fetchTasks()
            saveAndReloadData()
            self.resetSearchArray()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let t = tasksArray[indexPath.row]
        
        if let didSelectBool = t.valueForKey("isCompleted") as? Bool {
            
            if didSelectBool == false {
                
                t.setValue(true, forKey: "isCompleted")
                
            } else {
                
                t.setValue(false, forKey: "isCompleted")
            }
        }
        
        self.resetSearchArray()
        taskTableView.reloadData()
        self.saveAndReloadData()
        
    }
    
    //MARK: -Table View Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell", forIndexPath: indexPath) as! TaskTableViewCell
        let t = searchResults[indexPath.row]
        var dateCreatedVar = NSDate()
        var isComplete:Bool = false
        if let taskName = t.valueForKey("name") as? String {
            cell.taskNameLabel.text = taskName
        }
        if let createdDate = t.valueForKey("created") as? NSDate {
            let dateString = formatter.stringFromDate(createdDate)
            cell.createdDateLabel.text = dateString
            dateCreatedVar = createdDate
        }
        if let isCompleted:Bool = t.valueForKey("isCompleted") as? Bool {
            isComplete = isCompleted
        }
        
        if isComplete == true {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.taskNameLabel.textColor = UIColor.whiteColor()
            cell.accessoryType = .Checkmark
        }
        if isComplete == false {
            cell.accessoryType = .None
            cell.taskNameLabel.textColor = UIColor.blackColor()
            if self.secondsSinceCreated(dateCreatedVar) <= 120 {
                cell.backgroundColor = UIColor.greenColor()
            } else if self.secondsSinceCreated(dateCreatedVar) <= 300 {
                cell.backgroundColor = UIColor.yellowColor()
            } else {
                cell.backgroundColor = UIColor.redColor()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    //MARK: - Helper Methods
    
    func secondsSinceCreated(createdDate: NSDate) -> NSTimeInterval {
        
        let endDate = NSDate()
        
        let formatter = NSNumberFormatter()
        
        formatter.maximumFractionDigits = 0
        
        let timeInterval: Double = endDate.timeIntervalSinceDate(createdDate)
        
        return timeInterval
    }
    
    func restoreSearchBar(searchText: String) {
        if searchText == "" {
            self.searchBar.text = ""
            self.resetSearchArray()
        }
    }
    
    func saveAndReloadData() {
        do {
            
            try self.moc.save()
            
            print("I saved")
            
        } catch {
            
            print("I didn't save")
            
        }
        self.taskTableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        fetchTasks()
        self.taskTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    func resetSearchArray () {
        
        self.searchResults = self.tasksArray
        taskTableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func containsString(str: String, searchText: String) -> Bool {
        
        let lowercaseString = str.lowercaseString
        let lowercaseSearchText = searchText.lowercaseString
        
        return lowercaseString.hasPrefix(lowercaseSearchText)
    }
    
//    func filterContentForSearchText(searchText: String) {
//        
//        searchResults = tasksArray.filter({
//            
//            (city:String) -> Bool in
//            
//            let nameMatch = city.rangeOfString(searchText, options:.CaseInsensitiveSearch)
//            
//            return nameMatch != nil
//        })
//    }
    
}
