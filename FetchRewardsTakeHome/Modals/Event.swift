//
//  Event.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import Foundation

struct Event: Identifiable {
    let id: Int
    let title: String
    let imageUrl: String
    let state: String
    let city: String
    let date: String
    let time: String
}
