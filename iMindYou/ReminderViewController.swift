//
//  ViewController.swift
//  iMindYou
//
//  Created by Rajagopal on 6/23/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import UIKit
import os.log

class ReminderViewController: UIViewController {

    // MARK: view Outlets
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var dateTimePickerView: UIDatePicker!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: State variable
    var reminder : Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPassedReminder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let id = reminder?.id
        let title = titleTextView.text ?? ""
        let summary = summaryTextView.text ?? ""
        let dateTime = dateTimePickerView.date
        
        reminder = Reminder(id: id, title: title, summary: summary, timeStamp: dateTime)
    }
    
    // MARK: Actions
    @IBAction func cancelAction(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ReminderViewController is not inside a navigation controller.")
        }
    }
    
    // MARK: private methods
    
    private func loadPassedReminder() {
        // Set up views if editing an existing Reminder.
        if let reminder = reminder {
            navigationItem.title = reminder.title
            titleTextView.text   = reminder.title
            summaryTextView.text = reminder.summary
            dateTimePickerView.setDate(reminder.reminderTimestamp, animated: true)
        }
    }
    


}

