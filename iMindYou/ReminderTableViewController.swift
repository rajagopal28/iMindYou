//
//  ReminderViewController.swift
//  iMindYou
//
//  Created by Rajagopal on 6/26/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import UIKit
import os.log

class ReminderTableViewController: UITableViewController {
    
    var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadRemindersFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReminderViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderViewCell  else {
            fatalError("The dequeued cell is not an instance of ReminderViewCell.")
        }
        
        // Configure cell
        
        let reminder = reminders[indexPath.row]
        
        cell.titleLabel.text = "Title : " + reminder.title
        cell.descriptionLabel.text = "Description : " + reminder.summary
        cell.dateTimeLabel.text = "On : " + reminder.reminderTimestamp.description
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let reminder = reminders[indexPath.row]
            let _ = reminder.delete()
            
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

       // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new reminder.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let reminderDetailViewController = segue.destination as? ReminderViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReminderCell = sender as? ReminderViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReminderCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReminder = reminders[indexPath.row]
            reminderDetailViewController.reminder = selectedReminder
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadRemindersFromDB() {
        
        Reminder.initDB()
        let reminderList: [Reminder] = Reminder.all()
        if !reminderList.isEmpty {
            reminders += reminderList
        }
        print (reminders.count)
    }

    //MARK: Actions
    
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        
        
        
        if let sourceViewController = sender.source as? ReminderViewController, let reminder = sourceViewController.reminder {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let _ = reminder.update()
                reminders[selectedIndexPath.row] = reminder
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // save to db
                let _ = reminder.save()
                
                // Add a new reminder.
                let newIndexPath = IndexPath(row: reminders.count, section: 0)
                
                reminders.append(reminder)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
