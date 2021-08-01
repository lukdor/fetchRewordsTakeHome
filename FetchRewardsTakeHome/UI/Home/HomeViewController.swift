//
//  HomeViewController.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import UIKit

protocol ViewUpdateProvider: AnyObject {
    func handleResponse(_ response: Home.Events.Response)
}

extension Home {
    final class ViewController: UIViewController {
        private var presentationProvider: HomePresentationProvider?
        
        private let eventListTableView = UITableView()
        private var eventSearchBar = UISearchBar()
        private let refreshControl = UIRefreshControl()
        
        private enum Action {
            case updateTableView
            case sendRequest(Events.PresenterEvent)
        }
        
        init(presentationProvider: HomePresentationProvider) {
            self.presentationProvider = presentationProvider
            Log.Info(description: "Home.ViewController init")
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = presentationProvider?.backgroundColor
            configureViews()
        }
    }
}

//MARK: - conforms to UITableViewDelegate and UITableViewDataSource
extension Home.ViewController: UITableViewDelegate,
                               UITableViewDataSource {
    
    private func configureViews() {
        configureTableView()
        configureSearchBar()
    }
    
    private func configureTableView() {
        eventListTableView.translatesAutoresizingMaskIntoConstraints = presentationProvider?.maskAutoResizingIntoConstraints ?? false
        eventListTableView.delegate = self
        eventListTableView.dataSource = self
        refreshControl.addTarget(
            self,
            action: #selector(refreshTableView),
            for: .valueChanged
        )
        eventListTableView.refreshControl = refreshControl
        eventListTableView.backgroundColor = presentationProvider?.eventTableBackgroundColor
        eventListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        eventListTableView.register(
            presentationProvider?.eventTableCellType,
            forCellReuseIdentifier: presentationProvider?.eventTableCellId ?? Home.TableViewCell.cellId
        )
        
        view.addSubview(eventListTableView)
        
        let eventListTableViewConstraints = [
            eventListTableView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 50
            ),
            eventListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            eventListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            eventListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(eventListTableViewConstraints)
    }
    
    private func configureSearchBar() {
        eventSearchBar = UISearchBar(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 300,
                                                   height: 40))
        
        eventSearchBar.searchBarStyle = presentationProvider?.searchBarStyle ?? .default
        eventSearchBar.placeholder = presentationProvider?.searchBarTextFieldPlaceholder
        eventSearchBar.tintColor = presentationProvider?.searchBarTintColor
        let textFieldInsideSearchBar = eventSearchBar.value(forKey: presentationProvider?.searchBarTextFieldKey ?? "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = presentationProvider?.searchBarTextColor
        eventSearchBar.delegate = self
        navigationItem.titleView = eventSearchBar
    }
    
    @objc
    private func refreshTableView() {
        handleAction(.updateTableView)
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventCount = presentationProvider?.eventCount else {
            Log.error(
                description: "\(#file) - \(#function) - \(#line) presentation Provider is nil",
                isFatal: false
            )
            return 0
        }
        return eventCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: presentationProvider?.eventTableCellId ?? "",
                for: indexPath
            ) as? Home.TableViewCell,
            let strongPresentationProvider = presentationProvider,
            let size = presentationProvider?.eventCount,
            indexPath.row < size
        else {
            Log.error(
                description: "\(#file) - \(#function) - \(#line) TableViewCell Could not be created",
                isFatal: false
            )
            return UITableViewCell()
        }
        
        cell.configure(event: strongPresentationProvider.eventList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        guard
            let strongProvider = presentationProvider,
            indexPath.row < strongProvider.eventList.count,
            let selectedEvent = presentationProvider?.eventList[indexPath.row]
        else {
            Log.Info(description: "\(#function) - \(#line) \nUnknown error")
            return
        }
        
        handleAction(.sendRequest(.userClickedEvent(selectedEvent)))
    }
}

extension Home.ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        handleAction(.sendRequest(.userSearchingEvent(text)))
    }
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        guard let text = searchBar.text else { return }
        handleAction(.sendRequest(.userSearchingEvent(text)))
    }
}

// MARK: - Conforms to ViewUpdateProvider
extension Home.ViewController: ViewUpdateProvider {
    func handleResponse(_ response: Home.Events.Response) {
        switch response {
        case .fetchFinished:
            handleAction(.updateTableView)
        }
    }
}

extension Home.ViewController {
    private func handleAction(_ action: Action) {
        switch action {
        case .updateTableView:
            reloadTableView()
            
        case .sendRequest(let request):
            presentationProvider?.handlePresenterEvent(request)
        }
    }
}

extension Home.ViewController {
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.eventListTableView.reloadData()
        }
    }
}
