//
//  Coordinator.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import UIKit

protocol Coordinatable {
    var navigationController: UINavigationController { get }
    
    func start()
    func makeViewController() -> UIViewController
}
