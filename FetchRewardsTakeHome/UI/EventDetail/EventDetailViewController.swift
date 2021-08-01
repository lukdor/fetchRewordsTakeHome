//
//  EventDetailViewController.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/29/21.
//

import UIKit

protocol EventDetailPresentationUpdatable {
    func updateView()
}

extension EventDetail {
    final class ViewController: UIViewController, EventDetailPresentationUpdatable {
        
        private let presentationProvider: EventDetailPresentationProvider
        private let eventTitleLabel = UILabel()
        private let isFavoritedImageView = UIImageView()
        private let backButton = UIButton()
        private let eventImageView = UIImageView()
        private let seperator = UIView()
        private let eventDateLabel = UILabel()
        private let eventPlaceLabel = UILabel()
        
        private var safe: UILayoutGuide {
            view.safeAreaLayoutGuide
        }
        
        init(presentationProvider: EventDetailPresentationProvider) {
            self.presentationProvider = presentationProvider
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            super.loadView()
            navigationController?.setNavigationBarHidden(
                true,
                animated: false
            )
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = presentationProvider.backgroundColor
            configureBackButton()
            configureTitle()
            configueIsFavoritedImageView()
            addSeperator()
            configureEventImage()
            configureEventDateLabel()
            configureEventPlace()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(
                false,
                animated: false
            )
        }
    }
}

extension EventDetail.ViewController {
    private func configureBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(
            presentationProvider.backButtonImage,
            for: .normal
        )
        backButton.contentMode = presentationProvider.contentMode
        
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        
        backButton.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        view.addSubview(backButton)
        let safe = view.safeAreaLayoutGuide
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: safe.topAnchor),
            backButton.leftAnchor.constraint(
                equalTo: safe.leftAnchor,
                constant: 5
            ),
            backButton.widthAnchor.constraint(equalToConstant: presentationProvider.backButtonWidth),
            backButton.heightAnchor.constraint(equalToConstant: presentationProvider.backButtonHeight)
        ]
        
        NSLayoutConstraint.activate(backButtonConstraints)
    }
    
    @objc
    private func backButtonTapped() {
        presentationProvider.handlePresenterEvent(.backClicked)
    }
}

extension EventDetail.ViewController {
    private func configureTitle() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eventTitleLabel.numberOfLines = presentationProvider.eventTitleLabelNumberOfLines
        eventTitleLabel.textColor = presentationProvider.eventTitleLabelTextColor
        eventTitleLabel.textAlignment = presentationProvider.eventTitleTextAlignment
        eventTitleLabel.text = presentationProvider.eventTitle
        eventTitleLabel.font = presentationProvider.eventTitleLabelFont
        
        view.addSubview(eventTitleLabel)
        let eventTitleLabelConstraints = [
            eventTitleLabel.topAnchor.constraint(
                equalTo: safe.topAnchor,
                constant: 10
            ),
            eventTitleLabel.leftAnchor.constraint(
                equalTo: backButton.rightAnchor,
                constant: 10
            ),
            eventTitleLabel.rightAnchor.constraint(
                equalTo: safe.rightAnchor,
                constant:  -40
            )
        ]
        
        NSLayoutConstraint.activate(eventTitleLabelConstraints)
    }
}

extension EventDetail.ViewController {
    private func configueIsFavoritedImageView() {
        isFavoritedImageView.translatesAutoresizingMaskIntoConstraints = false
        isFavoritedImageView.image = presentationProvider.heartImage
        isFavoritedImageView.contentMode = presentationProvider.contentMode
        isFavoritedImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(heartClicked)
        )
        
        isFavoritedImageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(isFavoritedImageView)
        let isFavoritedImageViewConstraints = [
            isFavoritedImageView.rightAnchor.constraint(equalTo: safe.rightAnchor, constant: -10),
            isFavoritedImageView.centerYAnchor.constraint(equalTo: eventTitleLabel.centerYAnchor),
            isFavoritedImageView.widthAnchor.constraint(equalToConstant: presentationProvider.isFavoritedImageViewWidth),
            isFavoritedImageView.heightAnchor.constraint(equalToConstant: presentationProvider.isFavoritedImageViewHeight)
        ]
        
        NSLayoutConstraint.activate(isFavoritedImageViewConstraints)
    }
    
    @objc
    private func heartClicked() {
        Log.Info(description: "user favorited event: \(presentationProvider.eventTitle)")
        presentationProvider.handlePresenterEvent(.heartClicked)
    }
}

extension EventDetail.ViewController {
    private func addSeperator() {
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = presentationProvider.seperatorBavkgroundColor
        
        view.addSubview(seperator)
        
        let seperatorCosntraints = [
            seperator.heightAnchor.constraint(equalToConstant: presentationProvider.seperatorHeight),
            seperator.leftAnchor.constraint(equalTo: safe.leftAnchor),
            seperator.rightAnchor.constraint(equalTo: safe.rightAnchor),
            seperator.topAnchor.constraint(
                equalTo: eventTitleLabel.bottomAnchor,
                constant: 10
            )
        ]
        
        NSLayoutConstraint.activate(seperatorCosntraints)
    }
}

extension EventDetail.ViewController {
    private func configureEventImage() {
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.sd_setImage(with: presentationProvider.eventImageUrl)
        eventImageView.contentMode = presentationProvider.contentMode
        view.addSubview(eventImageView)
        
        let eventImageViewConstraints = [
            eventImageView.topAnchor.constraint(
                equalTo: seperator.bottomAnchor,
                constant: 5
            ),
            eventImageView.leftAnchor.constraint(
                equalTo: safe.leftAnchor,
                constant: 10
            ),
            eventImageView.rightAnchor.constraint(
                equalTo: safe.rightAnchor,
                constant: -10
            ),
            eventImageView.heightAnchor.constraint(equalToConstant: presentationProvider.eventImageHeight)
        ]
        
        NSLayoutConstraint.activate(eventImageViewConstraints)
    }
}

extension EventDetail.ViewController {
    private func configureEventDateLabel() {
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.numberOfLines = presentationProvider.eventDateLabelNumberOfLines
        eventDateLabel.text = presentationProvider.eventDateTime
        eventDateLabel.font = presentationProvider.eventDateLabelFont
        eventDateLabel.textAlignment = presentationProvider.eventDateTextAlingment
        eventDateLabel.textColor = presentationProvider.eventDateLabelTextColor
        
        view.addSubview(eventDateLabel)
        
        let eventDateLabelConstraints = [
            eventDateLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 5),
            eventDateLabel.leftAnchor.constraint(equalTo: safe.leftAnchor, constant: 10),
            eventDateLabel.rightAnchor.constraint(equalTo: safe.rightAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(eventDateLabelConstraints)
    }
    
    private func configureEventPlace() {
        eventPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        eventPlaceLabel.numberOfLines = presentationProvider.eventPlaceNumberOfLines
        eventPlaceLabel.textColor = presentationProvider.eventPlaceLabelTextColor
        eventPlaceLabel.textAlignment = presentationProvider.eventPlaceTextAlignment
        eventPlaceLabel.text = presentationProvider.eventPlaceText
        
        view.addSubview(eventPlaceLabel)
        
        let eventPlaceLabelConstraints = [
            eventPlaceLabel.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 10),
            eventPlaceLabel.leftAnchor.constraint(equalTo: safe.leftAnchor),
            eventPlaceLabel.rightAnchor.constraint(equalTo: safe.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(eventPlaceLabelConstraints)
    }
}

extension EventDetail.ViewController {
    func updateView() {
        Log.Info(description: "\(#function) \(#line) \(#fileID) viewUpdate initiated")
        isFavoritedImageView.image = presentationProvider.heartImage
    }
}
