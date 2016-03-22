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
    
    var resultsArray = [Task]()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.resultsArray = self.tasksArray
        self.taskTableView.reloadData()
    }
    
    //MARK: Unwind Segue, grabs new task from AddTaskViewController
    
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
        let c = resultsArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell")!
        cell.textLabel?.text = c.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsArray.count
        
    }
    
    //MARK: Search Bar Delegate Methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        
        for task in tasksArray {
            if self.containsString(task.name, searchText: searchText) {
                self.resultsArray.append(task)
            }
        }
        self.taskTableView.reloadData()
        self.restoreSearchBar(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.restoreSearchBar("")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.becomeFirstResponder()
    }
    
    //MARK: Helper Methods
    
    func restoreSearchBar(searchText: String) {
        if searchText == "" {
            self.searchBar.text = ""
            self.resultsArray = self.tasksArray
            self.taskTableView.reloadData()
            self.searchBar.resignFirstResponder()
        }
    }
    
    func containsString(str: String, searchText: String) -> Bool {
        
        let lowercaseString = str.lowercaseString
        let lowercaseSearchText = searchText.lowercaseString
        
        return lowercaseString.hasPrefix(lowercaseSearchText)
    }
    
}

