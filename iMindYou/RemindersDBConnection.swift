//
//  RemindersDBConnection.swift
//  iMindYou
//
//  Created by Rajagopal on 6/27/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import SQLite
import os.log

class RemindersDBConnection {
    
    // MARK: Database connection path
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    private var db : Connection?
    
    private static var instance : RemindersDBConnection?
    
    private init() {
        if db == nil {
            do {
                db = try Connection("\(path)/reminder.sqlite3")
            } catch {
                os_log("Database initialisation failed", log: OSLog.default, type: .error)
            }
        }
    }
    
    public static func getDB() -> Connection {
        if(instance == nil) {
            instance = RemindersDBConnection()
        }
        return (instance?.db)!
    }
}
