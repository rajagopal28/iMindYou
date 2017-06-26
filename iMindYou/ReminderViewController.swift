//
//  ViewController.swift
//  iMindYou
//
//  Created by Rajagopal on 6/23/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

    // MARK: view Outlets
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var dateTimePickerView: UIDatePicker!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

