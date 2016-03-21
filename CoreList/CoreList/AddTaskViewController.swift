//
//  AddTaskViewController.swift
//  CoreList
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var addedTaskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addTaskTapped(sender: BorderButton) {
        if addedTaskTextField.text == "" {
            
        } else {
            performSegueWithIdentifier("taskAddedSegue", sender: self)
        }
    }
    
    
}
 