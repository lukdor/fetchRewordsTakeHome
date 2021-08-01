//
//  EventDetailViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/29/21.
//

import UIKit

protocol EventDetailPresentationProvider: AnyObject {
    // MARK: - general
    var backgroundColor: UIColor { get }
    var contentMode: UIView.ContentMode { get }
    // MARK: - isFavorited
    var heartImage: UIImage { get }
    var isFavoritedImageViewHeight: CGFloat { get }
    var isFavoritedImageViewWidth: CGFloat { get }
    // MARK: - eventTitleLabel
    var eventTitle: String { get }
    var eventTitleLabelFont: UIFont { get }
    var eventTitleLabelNumberOfLines: Int { get }
    var eventTitleLabelTextColor: UIColor { get }
    var eventTitleTextAlignment: NSTextAlignment { get }
    // MARK: - eventImage
    var eventImageUrl: URL? { get }
    var eventImageHeight: CGFloat { get }
    // MARK: - backButton
    var backButtonImage: UIImage { get }
    var backButtonWidth: CGFloat { get }
    var backButtonHeight: CGFloat { get }
    // MARK: - seperator
    var seperatorBavkgroundColor: UIColor { get }
    var seperatorHeight: CGFloat { get }
    // MARK: - eventDate
    var eventDateTime: String { get }
    var eventDateLabelFont: UIFont { get }
    var eventDateLabelTextColor: UIColor { get }
    var eventDateLabelNumberOfLines: Int { get }
    var eventDateTextAlingment: NSTextAlignment { get }
    // MARK: - Event place
    var eventPlaceLabelTextColor: UIColor { get }
    var eventPlaceNumberOfLines: Int { get }
    var eventPlaceTextAlignment: NSTextAlignment { get }
    var eventPlaceText: String { get }
    
    func handlePresenterEvent(_ event: EventDetail.Events.PresenterEvent)
}

extension EventDetail {
    final class ViewModel: EventDetailPresentationProvider {
        
        let enviroment: Enviroment
        var presentorInteractor: EventDetailPresentationUpdatable?
        var eventRequester: EventDetailRequestable?
        
        enum Action {
            case togglePersistance
            case askViewUpdate
            case requestNavigationPop
        }
        
        struct Enviroment {
            let event: Event
            let persistance: UserDefaults
        }
        
        init(
            enviroment: Enviroment,
            eventRequester: EventDetailRequestable
        ) {
            self.enviroment = enviroment
            self.eventRequester = eventRequester
        }
    }
}

extension EventDetail.ViewModel {
    var backgroundColor: UIColor { #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    
    var contentMode: UIView.ContentMode { .scaleAspectFit }
    
    private var eventDate: Date {
        Date.changeDateByString(enviroment.event.date)
    }
    
    // MARK: - isFavoritedImageViewPresentation data
    var heartImage: UIImage {
        guard isFavorited else {
            return UIImage(named: "heart") ?? UIImage()
        }
        return UIImage(named: "heart-filled") ?? UIImage()
    }
    
    var isFavoritedImageViewHeight: CGFloat { 20 }
    
    var isFavoritedImageViewWidth: CGFloat { 20 }
    
    private var isFavorited: Bool {
        enviroment.persistance.bool(forKey: "\(enviroment.event.id)")
    }
    
    //MARK: - backButton presentation data
    var backButtonImage: UIImage { UIImage(named: "chevron_left") ?? UIImage() }
    
    var backButtonWidth: CGFloat { 40 }
    
    var backButtonHeight: CGFloat { 40 }
    
    //MARK: - eventTitleLabel presentation data
    var eventTitle: String { enviroment.event.title }
    
    var eventTitleLabelNumberOfLines: Int { 6 }
    
    var eventTitleLabelTextColor: UIColor { #colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1) }
    
    var eventTitleTextAlignment: NSTextAlignment { .center }
    
    var eventTitleLabelFont: UIFont {
        UIFont.systemFont(
            ofSize: 20,
            weight: .bold
        )
    }
    
    // MARK: - eventImageView Presentation data
    var eventImageUrl: URL? {
        URL(string: enviroment.event.imageUrl)
    }
    
    var eventImageHeight: CGFloat { 300 }
    
    // MARK: - seperator presentation data
    var seperatorHeight: CGFloat { 0.3 }
    
    var seperatorBavkgroundColor: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    //MARK: - eventDate presentation data
    private var eventDayString: String { eventDate.dayName }
    private var eventDayNumber: String { eventDate.day }
    private var eventMonth: String { eventDate.monthName }
    private var eventYear: String { eventDate.year }
    private var eventTime: String { eventDate.imperialTime }
    var eventDateTime: String {
        return "\(eventDayString), \(eventDayNumber) \(eventMonth) \(eventYear) \(eventTime)"
    }
    
    var eventDateLabelFont: UIFont {
        UIFont.systemFont(ofSize: 19, weight: .bold)
    }
    
    var eventDateTextAlingment: NSTextAlignment { .center }
    
    var eventDateLabelTextColor: UIColor { #colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1) }
    
    var eventDateLabelNumberOfLines: Int { 1 }
    
    // MARK: - EventPlace presentation data
    private var eventPlaceState: String { enviroment.event.state }
    
    private var eventPlaceCity: String { enviroment.event.city }
    
    var eventPlaceText: String {
        "\(eventPlaceCity), \(eventPlaceState)"
    }
    
    var eventPlaceLabelTextColor: UIColor { #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) }
    
    var eventPlaceNumberOfLines: Int { 1 }
    
    var eventPlaceTextAlignment: NSTextAlignment { .center }
}

extension EventDetail.ViewModel {
    func handleAction(_ action: Action) {
        switch action {
        case .togglePersistance:
            togglePersistance()
            
        case .askViewUpdate:
            presentorInteractor?.updateView()
            
        case.requestNavigationPop:
            eventRequester?.handleEvent(.popController)
        }
    }
}

extension EventDetail.ViewModel {
    func handlePresenterEvent(_ event: EventDetail.Events.PresenterEvent) {
        switch event {
        case .heartClicked:
            handleAction(.togglePersistance)
            
        case .backClicked:
            handleAction(.requestNavigationPop)
        }
    }
}

extension EventDetail.ViewModel {
    func togglePersistance() {
        print(enviroment.persistance.bool(forKey: "\(enviroment.event.id)"))
        if enviroment.persistance.bool(forKey: "\(enviroment.event.id)") {
            enviroment.persistance.setValue(
                false,
                forKey: "\(enviroment.event.id)"
            )
        }
        else {
            enviroment.persistance.setValue(
                true,
                forKey: "\(enviroment.event.id)"
            )
        }
        
        print(enviroment.persistance.bool(forKey: "\(enviroment.event.id)"))
        
        handleAction(.askViewUpdate)
    }
}
