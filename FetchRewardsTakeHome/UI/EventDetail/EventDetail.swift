//
//  EventDetail.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/28/21.
//

import Foundation

enum EventDetail {
    enum Events {}
}

extension EventDetail.Events {
    enum PresenterEvent {
        case heartClicked
        case backClicked
    }
    
    enum Request {
        case popController
    }
}


