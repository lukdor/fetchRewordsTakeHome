//
//  Home.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/28/21.
//

import Foundation

// namespace
enum Home { }

extension Home {
    enum Events {}
}

extension Home.Events {
    
    enum PresenterEvent {
        case userSearchingEvent(String)
        case userClickedEvent(Event)
    }
    
    enum Request {
        case navigationRequested(Event)
    }
    
    enum Response {
        case fetchFinished
    }
    
}


