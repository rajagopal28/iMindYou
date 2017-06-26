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
        
        let title = titleTextView.text ?? ""
        let summary = summaryTextView.text ?? ""
        let dateTime = dateTimePickerView.date
        
        reminder = Reminder(title: title, summary: summary, timeStamp: dateTime)
    }


}

