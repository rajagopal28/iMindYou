//
// Created by Rajagopal on 6/23/17.
// Copyright (c) 2017 Rajagopal. All rights reserved.
//

import Foundation

class Reminder: NSObject {

    // MARK: Properties
    var id: Int?
    var title: String
    var summary: String
    var reminderTimestamp: Date

    init?(id: Int?, title: String, summary: String, timeStamp: Date) {
        if title.isEmpty {
            return nil
        }
        if let id = id {
            self.id = id
        }
        self.title = title
        self.summary = summary
        self.reminderTimestamp = timeStamp
    }

}
