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
    public static func allPastReminders() -> [Reminder] {
        let db = RemindersDBConnection.getDB()
        var reminders = [Reminder]()
        do {
            let query = Reminder.table.select(Reminder.table[*])
                .filter(Reminder.reminderOnDate < Date())
                .order(Reminder.reminderOnDate.desc)
            for reminder in try db.prepare(query) {
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
    public static func allUpcomingReminders() -> [Reminder] {
        let db = RemindersDBConnection.getDB()
        var reminders = [Reminder]()
        do {
            let query = Reminder.table.select(Reminder.table[*])
                .filter(Reminder.reminderOnDate >= Date())
                .order(Reminder.reminderOnDate.desc)
            for reminder in try db.prepare(query) {
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
    
    public static func todayReminderCount() -> Int {
        let db = RemindersDBConnection.getDB()
        do {
            let now = Date()
            let endTime = getEndTimeOfDate(mDate: now)
            let count = try db.scalar(Reminder.table.filter(Reminder.reminderOnDate >= now && Reminder.reminderOnDate <= endTime).count)
            return count
        } catch {
            os_log("Count of today reminders failed all failed", log: OSLog.default, type: .error)
        }
        return 0
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
            os_log("Insert Failed", log: OSLog.default, type: .error)
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
    
    // MARK: private methods
    private static func getEndTimeOfDate(mDate: Date) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: mDate)
        // Change the time to 23:59:59 in your locale
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let endTime = gregorian.date(from: components)!
        return endTime
    }
}
