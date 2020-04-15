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
    var options: [Place] = []
    var voteEnded: Bool = false
    var votes: [Place: Int] = [:]
    
    init(title: String, dateOfEvent: Date, endingDate: Date, options: [Place]) {
        self.uid = UUID()
        self.titleOfVote = title
        self.dateOfEvent = dateOfEvent
        self.endingDate = endingDate
        self.options = options
        
        print("Vote constructed")
        constructVoteCounter(options)
    }
    
    // allows to keep track of the vote for each choice
    func constructVoteCounter(_ choices: [Place]) {
        choices.forEach { (place) in
            votes[place] = 0
        }
        printVotes()
    }
    
    // helper method to check votes dictionary
    func printVotes() {
        print("\n")
        for vote in self.votes {
            print("\(vote.key.name) has \(vote.value) votes ")
        }
    }
    
    func incrementVote( _ option: Place) {
        if votes.keys.contains(option) {
            if votes[option]! >= 1 {
                votes[option]! -= 1
            } else {
                votes[option] = 0
            }
        }
    }
    
    func decreaseVote(_ option: Place) {
        if votes.keys.contains(option) {
            votes[option]! += 1
        }
    }
}

