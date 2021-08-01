//
//  HomeCoordinator.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import UIKit

protocol HomeCoordinatable: Coordinatable, EventRequestable {
    func setViewController(_ controller: UIViewController)
    func setupNavigationBar()
}

protocol EventRequestable: AnyObject {
    func handleRequestEvent (_ event: Home.Events.Request)
}

extension Home {
    final class Coordinator: HomeCoordinatable {
        var navigationController: UINavigationController
        lazy var homeViewModel = Home.ViewModel(requestMaker: self)
        
        init (navigationController: UINavigationController) {
            Log.Info(description: "\(#function) \(#line)\nHome Coordinator init")
            self.navigationController = navigationController
        }
        
        private enum Action {
            case setViewController
            case setupNavigationBar
            case navigate(Event)
        }
        
        func start() {
            Log.Info(description: "\(#function) \(#line) Home.Coordinator start")
            setupNavigationBar()
            setViewController(makeViewController())
        }
        
        func makeViewController() -> UIViewController {
            Log.Info(description: "\(#function) \(#line) Home.Coordinator makeViewController")
            let controller = Home.ViewController(presentationProvider: homeViewModel)
            homeViewModel.viewUpdateProvider = controller
            return controller
        }
        
        func setViewController(_ controller: UIViewController) {
            navigationController.setViewControllers(
                [controller],
                animated: false
            )
        }
        
        func setupNavigationBar() {
            navigationController.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navigationController.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
            navigationController.navigationBar.prefersLargeTitles = false
        }
        
        private func createCoordinator(event: Event) -> EventDetail.Coordinator {
            EventDetail.Coordinator(
                navigationController: navigationController,
                enviroment: .init(selectedEvent: event)
            )
        }
    }
}

extension Home.Coordinator {
    func handleRequestEvent(_ event: Home.Events.Request) {
        switch event {
        case .navigationRequested(let event):
            handleAction(.navigate(event))
        }
    }
}

extension Home.Coordinator {
    private func handleAction(_ action: Action) {
        Log.Info(description: "\(#function) \(#line) Home.Coordinator handle action \(action)")
        switch action {
        case .setViewController:
            setViewController(makeViewController())
            
        case .setupNavigationBar:
            setupNavigationBar()
            
        case .navigate(let event):
            createCoordinator(event: event).start()
        }
    }
}


