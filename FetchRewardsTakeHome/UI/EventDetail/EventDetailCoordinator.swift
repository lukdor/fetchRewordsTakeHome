//
//  EventDetailCoordinator.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/28/21.
//

import UIKit

protocol EventDetailRequestable: AnyObject {
    func handleEvent(_ event: EventDetail.Events.Request)
}

extension EventDetail {
    final class Coordinator: Coordinatable, EventDetailRequestable {
        var navigationController: UINavigationController
        let enviroment: Enviroment
        
        private enum Action {
            case pushController
            case popController
        }
        
        struct Enviroment {
            let selectedEvent: Event
        }
        
        init(
            navigationController: UINavigationController,
            enviroment: Enviroment
        ) {
            self.navigationController = navigationController
            self.enviroment = enviroment
        }
        
        func start() {
            handleAction(.pushController)
        }
        
        private func handleAction(_ action: Action) {
            switch action {
            case .pushController:
                navigationController.pushViewController(makeViewController(), animated: true)
            case .popController:
                navigationController.popViewController(animated: true)
            }
        }
        
        func makeViewController() -> UIViewController {
            let viewModel = ViewModel(
                enviroment: .init(
                    event: enviroment.selectedEvent,
                    persistance: UserDefaults.standard
                ),
                eventRequester: self
            )
            let controller = ViewController(presentationProvider: viewModel)
            viewModel.presentorInteractor = controller
            return controller
        }
        
        func handleEvent(_ event: EventDetail.Events.Request) {
            switch event {
            case .popController:
                handleAction(.popController)
            }
        }
    }
}
