//
//  Reminder+SQLite.swift
//  iMindYou
//
//  Created by Rajagopal on 6/27/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import Foundation
import SQLite
import os.log

extension Reminder {
    // MARK: Table decleration
    static let table = Table("reminders")
    
    // MARK: DB Fields decleration
    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let description = Expression<String>("description")
    static let reminderOnDate = Expression<Date>("reminder_on_date")
    
    // MARK: public static methods common to all instances
    public static func initDB() {
        let db = RemindersDBConnection.getDB()
        
        do {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(description)
                t.column(reminderOnDate)
            })
        } catch {
            os_log("Table creation failed", log: OSLog.default, type: .error)
        }
    }
    public static func all() -> [Reminder] {
        let db = RemindersDBConnection.getDB()
        var reminders = [Reminder]()
        do {
            for reminder in try db.prepare(Reminder.table) {
                if let reminderObj = Reminder(
                    id: Int(reminder[id]),
                    title: reminder[Reminder.title],
                    summary: reminder[Reminder.description],
                    timeStamp: reminder[Reminder.reminderOnDate]){
                    reminders.append(reminderObj)                }
            }
        } catch {
            os_log("Select all failed", log: OSLog.default, type: .error)
        }
        return reminders
    }
    
    // MARK: Public methods of instance
    public func save() -> Bool {
        let db = RemindersDBConnection.getDB()
        do {
            let insert = Reminder.table.insert( Reminder.title <- self.title,
                                                Reminder.description <- self.summary,
                                                Reminder.reminderOnDate <- self.reminderTimestamp)
            let id = try db.run(insert)
            self.id = Int(id)
            
            return true
        } catch {
            os_log("Select all failed", log: OSLog.default, type: .error)
            print("Insert failed")
            return false
        }
    }
    
    public func delete() -> Bool {
        if let id = self.id {
            let db = RemindersDBConnection.getDB()
            do {
                let reminder = Reminder.table.filter(Reminder.id == Int64(id))
                try db.run(reminder.delete())
                return true
            } catch {
                os_log("Delete failed", log: OSLog.default, type: .error)            }
        }
        return false
    }
    
    public func update() -> Bool {
        if let id = self.id {
            let db = RemindersDBConnection.getDB()
            do {
                let reminder = Reminder.table.filter(Reminder.id == Int64(id))
                try db.run(reminder.update(Reminder.title <- self.title,
                                            Reminder.description <- self.summary,
                                            Reminder.reminderOnDate <- self.reminderTimestamp))
                return true
            } catch {
                os_log("Update failed", log: OSLog.default, type: .error)
            }
        }
        return false
    }
}
