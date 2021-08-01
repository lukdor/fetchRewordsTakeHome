//
//  LogManager.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/31/21.
//

import Foundation

class Log {
    static func Info(description: String) {
        DispatchQueue.global(qos: .background).async {
            print("-----I-----")
            print(description)
        }
    }
    
    static func error(
        description: String,
        isFatal: Bool
    ) {
        DispatchQueue.global(qos: .background).async {
            print("-----E-----")
            if isFatal {
                fatalError(description)
            } else {
                print(description)
            }
        }
    }
}
