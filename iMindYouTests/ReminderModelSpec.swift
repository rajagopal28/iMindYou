//
// Created by Rajagopal on 6/23/17.
// Copyright (c) 2017 Rajagopal. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import iMindYou

class ReminderModelSpec: QuickSpec {
    override func spec() {
        describe("test Reminder model") {
            it("Should create ReminderModel if the title is not empty") {
                let reminder = Reminder(title: "Some title", summary: "short summary", timeStamp: Date())
                expect(reminder).notTo(beNil())
                expect(reminder?.title).to(equal("Some title"))
            }
            
            it("Should return nil if the title is empty") {
                let reminder = Reminder(title: "", summary: "short summary", timeStamp: Date())
                expect(reminder).to(beNil())
            }
        }
    }
}
