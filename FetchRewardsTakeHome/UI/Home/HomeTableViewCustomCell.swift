//
//  HomeTableViewCustomCell.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/27/21.
//

import UIKit
import SDWebImage

extension Home {
    final class TableViewCell: UITableViewCell {
        
        lazy var safeArea = contentView.safeAreaLayoutGuide
        
        static let cellId = "homeTableViewCellId"
        
        private let eventImage = UIImageView()
        private let titleLabel = UILabel()
        private let locationLabel = UILabel()
        private let dateLabel = UILabel()
        private let timeLabel = UILabel()
        private var heartImage = UIImageView()

        
        func configure(event: Event) {
            configureEventImage(imageUrl: event.imageUrl)
            configureTitle(event.title)
            configureLocationLabel(city: event.city, state: event.state)
            configureDate(date: event.date)
            configureTimeLabel(dateString: event.date)
            configureHeartImage(id: event.id)
        }
    }
}

extension Home.TableViewCell {
    private func configureEventImage(imageUrl: String) {
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        let url = URL(string: imageUrl)
        eventImage.contentMode = .scaleAspectFill
        eventImage.layer.cornerRadius = 10
        eventImage.layer.masksToBounds = true
        eventImage.sd_setImage(with: url)
        contentView.addSubview(eventImage)
        
        let eventImageConstraints = [
            eventImage.widthAnchor.constraint(equalToConstant: 60),
            eventImage.heightAnchor.constraint(equalToConstant: 60),
            eventImage.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 20
            ),
            eventImage.leftAnchor.constraint(
                equalTo: safeArea.leftAnchor,
                constant: 20
            )
        ]
        
        NSLayoutConstraint.activate(eventImageConstraints)
    }
    
    private func configureTitle(_ title: String) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        titleLabel.font = UIFont.systemFont(
            ofSize: 15,
            weight: .bold
        )
        
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: eventImage.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: eventImage.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    private func configureLocationLabel(city: String, state: String) {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = "\(city), \(state)"
        locationLabel.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )
        locationLabel.textColor = .gray
        
        contentView.addSubview(locationLabel)
        
        let locationLabelConstraints = [
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            locationLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(locationLabelConstraints)
    }
    
    private func configureDate(date: String) {
        let eventDate = Date.changeDateByString(date)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "\(eventDate.dayName), \(eventDate.day), \(eventDate.monthName) \(eventDate.year)"
        
        dateLabel.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )
        
        dateLabel.textColor = .gray
        contentView.addSubview(dateLabel)
        
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            dateLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: locationLabel.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    private func configureTimeLabel(dateString: String) {
        let eventDate = Date.changeDateByString(dateString)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = eventDate.imperialTime
        
        timeLabel.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )
        
        timeLabel.textColor = .gray
        
        contentView.addSubview(timeLabel)
        
        let timeLabelConstraints = [
            timeLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 1
            ),
            timeLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor),
            timeLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor),
            timeLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ]
        
        NSLayoutConstraint.activate(timeLabelConstraints)
        
    }
    
    private func configureHeartImage(id: Int) {
        let defaults = UserDefaults.standard
        
        guard defaults.bool(forKey: "\(id)") else {
            return
        }
        
        heartImage = UIImageView(
            frame: CGRect(
                x: eventImage.bounds.minX + 5,
                y: eventImage.bounds.minY + 12,
                width: 20,
                height: 20
            )
        )
        
        heartImage.image = UIImage(named: "heart-filled")
        heartImage.contentMode = .scaleAspectFit
        
        contentView.addSubview(heartImage)
        
    }
}

extension Home.TableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImage.image = UIImage()
        titleLabel.text = ""
        locationLabel.text = ""
        dateLabel.text = ""
        timeLabel.text = ""
        heartImage.image = UIImage()
    }
}
