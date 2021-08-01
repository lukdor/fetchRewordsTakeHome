//
//  HomeViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol HomePresentationProvider: AnyObject {
    // MARK: - General
    var backgroundColor: UIColor { get }
    var maskAutoResizingIntoConstraints: Bool { get }
    // MARK: - searchBar
    var searchBarTextColor: UIColor { get }
    var searchBarTintColor: UIColor { get }
    var searchBarTextFieldKey: String { get }
    var searchBarTextFieldPlaceholder: String { get }
    var searchBarStyle: UISearchBar.Style { get }
    // MARK: - eventTableView
    var eventTableBackgroundColor: UIColor { get }
    var eventTableCellType: Home.TableViewCell.Type { get }
    var eventTableCellId: String { get }
    var eventList: [Event] { get }
    var eventCount: Int { get }
    
    func handlePresenterEvent(_ event: Home.Events.PresenterEvent)
}

extension Home {
    final class ViewModel: HomePresentationProvider {
        
        init(requestMaker: EventRequestable) {
            Log.Info(description: "\(#function) \(#line) Home.ViewModel init")
            self.requestMaker = requestMaker
        }
        
        private enum Action {
            case sendResponse(Events.Response)
            case searchEvent(String)
            case makeRequest(Events.Request)
        }
        
        // MARK: - View Data
        var backgroundColor: UIColor { #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        var maskAutoResizingIntoConstraints: Bool { false }
        
        // MARK: - Search Bar
        var searchBarTextColor: UIColor { #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        var searchBarTintColor: UIColor { #colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1) }
        var searchBarTextFieldKey: String { "searchField" }
        var searchBarTextFieldPlaceholder: String { "Search" }
        var searchBarStyle: UISearchBar.Style { .default }
        
        // MARK: - Table View
        var eventTableBackgroundColor: UIColor { .clear }
        var eventTableCellType: Home.TableViewCell.Type { Home.TableViewCell.self }
        var eventTableCellId: String { Home.TableViewCell.cellId }
        var eventList: [Event] = []
        var eventCount: Int { eventList.count }
        
        weak var viewUpdateProvider: ViewUpdateProvider?
        var requestMaker: EventRequestable
    }
}

extension Home.ViewModel {
    private func handleAction(_ action: Action) {
        Log.Info(description: "\(#function) action: \(action)")
        switch action {
        case .sendResponse(let response):
            Log.Info(description: "\(#function) \(#file) \(response)")
            viewUpdateProvider?.handleResponse(response)
            
        case .searchEvent(let searchString):
            Log.Info(description: "search: \(searchString)")
            makeSearch(searchString)
            
        case .makeRequest(let request):
            Log.Info(description: "request: \(request)")
            requestMaker.handleRequestEvent(request)
        }
    }
}

extension Home.ViewModel {
    func handlePresenterEvent(_ event: Home.Events.PresenterEvent) {
        switch event {
        case .userSearchingEvent(let searchString):
            handleAction(.searchEvent(searchString))
            
        case .userClickedEvent(let event):
            handleAction(.makeRequest(.navigationRequested(event)))
        }
    }
}

extension Home.ViewModel {
    private func makeSearch(
        _ search: String
    ) {
        guard let _search = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            Log.error(description: "\(#function) \(#line) makeSearch \nCould not add percent encoding", isFatal: false)
            return
        }
        
        guard SecretKeys.client_id != "" else {
            Log.error(description: "\(#function) please enter an API key", isFatal: true)
            return
        }
        
        let url = "https://api.seatgeek.com/2/events?q=\(_search)&client_id=\(SecretKeys.client_id)"
        
        DispatchQueue.main.async {
            self.eventList.removeAll()
        }
        
        AF.request(url).responseJSON { [weak self] jsonResponse in
            switch jsonResponse.result {
            
            case .success(let result):
                let json = JSON(result)
                self?.jsonFetcher(json)
                
            case .failure(let err):
                Log.error(
                    description: err.localizedDescription,
                    isFatal: false
                )
            }
        }
    }
    
    private func jsonFetcher(_ json: JSON) {
        guard let events = json.dictionary?["events"]?.array else { return }
        for event in events {
            guard
                let id = event.dictionary?["id"]?.int,
                let title = event.dictionary?["short_title"]?.string,
                let state = event.dictionary?["venue"]?.dictionary?["state"]?.string,
                let city = event.dictionary?["venue"]?.dictionary?["city"]?.string,
                let startDate = event.dictionary?["datetime_local"]?.string,
                let imageUrl = event.dictionary?["performers"]?.array?[0].dictionary?["image"]?.string
            else {
                Log.error(
                    description: "error fetchin json",
                    isFatal: false
                )
                return
            }
            eventList.append(
                Event(
                    id: id,
                    title: title,
                    imageUrl: imageUrl,
                    state: state,
                    city: city,
                    date: startDate,
                    time: startDate
                )
            )
        }
        handleAction(.sendResponse(.fetchFinished))
    }
}


    
