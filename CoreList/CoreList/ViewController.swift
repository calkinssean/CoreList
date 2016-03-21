//
//  ViewController.swift
//  CoreList
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var taskTableView: UITableView!
    
    var tasksArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

   
    @IBAction func newTaskAdded (segue: UIStoryboardSegue) {
        
        if segue.identifier == "taskAddedSegue" {
            let unwindInfo = segue.sourceViewController as! AddTaskViewController
            let t = Task()
            if let taskName = unwindInfo.addedTaskTextField.text {
                t.name = taskName
            }
            self.tasksArray.append(t)
            self.taskTableView.reloadData()
            
        }
        
    }

    //MARK: Table View Delegate Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let c = tasksArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell")!
        cell.textLabel?.text = c.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksArray.count
        
    }
    
    

}

