//
//  Vote.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/12/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation

// A class not a struct to allow subclassing into different types of votes in the future

class Vote {
    var uid: UUID
    var titleOfVote: String = ""
    var dateOfEvent: Date
    var endingDate: Date
    var choices: [Place] = []
    var voteEnded: Bool = false
    
    init(title: String, dateOfEvent: Date, endingDate: Date) {
        self.uid = UUID()
        self.titleOfVote = title
        self.dateOfEvent = dateOfEvent
        self.endingDate = endingDate
    }
}
