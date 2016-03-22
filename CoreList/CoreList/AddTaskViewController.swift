//
//  AddTaskViewController.swift
//  CoreList
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addedTaskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addedTaskTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addedTaskTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func addTaskTapped(sender: BorderButton) {
        if addedTaskTextField.text == "" {
            
        } else {
            performSegueWithIdentifier("taskAddedSegue", sender: self)
        }
    }
    
    
}
 