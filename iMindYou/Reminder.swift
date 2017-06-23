//
// Created by Rajagopal on 6/23/17.
// Copyright (c) 2017 Rajagopal. All rights reserved.
//

import Foundation

class Reminder: NSObject {

    //MARK: Properties
    var title: String
    var summary: String
    var reminderTimestamp: Date

    init?(title: String, summary: String, timeStamp: Date) {
        if title.isEmpty {
            return nil
        }
        self.title = title
        self.summary = summary
        self.reminderTimestamp = timeStamp
    }

}