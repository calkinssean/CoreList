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
    
    var formatter = NSDateFormatter()
    
    var nameString:String = ""
    
    var tasksArray = [NSManagedObject]()
    
    var moc = DataController().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM/d/yyyy HH:mm:ss"
        self.fetchTasks()
    }
    
    @IBAction func addTask(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add", message: "Add a task", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (alertAction) -> Void in
            if let textField = alertController.textFields?.first, let text = textField.text {
                self.saveTask(text)
                self.taskTableView.reloadData()
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
                self.taskTableView.reloadData()
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
                
                self.tasksArray.insert(task, atIndex: 0)
                
            } catch {
                
                print("I didn't save the task")
                
            }
        }
        
    }
    
    //MARK: -Table View Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell", forIndexPath: indexPath) as! TaskTableViewCell
        let t = tasksArray[indexPath.row]
        var dateCreatedVar = NSDate()
        if let taskName = t.valueForKey("name") as? String {
            cell.taskNameLabel.text = taskName
        }
        if let createdDate = t.valueForKey("created") as? NSDate {
            let dateString = formatter.stringFromDate(createdDate)
            cell.createdDateLabel.text = dateString
            dateCreatedVar = createdDate
        }
        if self.minutesSinceCreated(dateCreatedVar) <= 120 {
            cell.backgroundColor = UIColor.greenColor()
        } else if self.minutesSinceCreated(dateCreatedVar) <= 300 {
            cell.backgroundColor = UIColor.yellowColor()
        } else {
            cell.backgroundColor = UIColor.redColor()
        }
        
    

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func minutesSinceCreated(createdDate: NSDate) -> NSTimeInterval {
        
        let endDate = NSDate()
        
        let formatter = NSNumberFormatter()
        
        formatter.maximumFractionDigits = 4
        
        let timeInterval: Double = endDate.timeIntervalSinceDate(createdDate);
        let numberString = formatter.stringFromNumber(timeInterval)
        print("elapsed Time: \(numberString!)")
        return timeInterval
    }
    
}
