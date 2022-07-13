//
//  BarChartCell.swift
//  BarChart
//
//  Created by Nishant Taneja on 13/07/22.
//

import UIKit

final class BarChartCell: UICollectionViewCell {
    private let barBackgroundView = UIView()
    private let barView = UIView()
    private lazy var barStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [barBackgroundView, barView])
        stackView.axis = .vertical
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var barViewHeightConstraint: NSLayoutConstraint! = nil
    private var barViewHeight: CGFloat {
        get {
            barViewHeightConstraint.constant
        }
        set {
            barViewHeightConstraint.constant = newValue
        }
    }
    private var barViewWidthConstraint: NSLayoutConstraint! = nil
    private var barViewWidth: CGFloat {
        get {
            barViewWidthConstraint.constant
        }
        set {
            barViewWidthConstraint.constant = newValue
        }
    }
    var barWidth: CGFloat = defaultBarWidth
    var shouldUseEstimatedWidth: Bool = false {
        willSet {
            if newValue {
                barViewWidth = barWidth
                if barWidth < 10 {
                    titleLabel.text = nil
                }
            } else {
                barViewWidth = barWidth
            }
        }
    }
    
    var barBackgroundColor: UIColor? {
        get {
            barBackgroundView.backgroundColor
        }
        set {
            barBackgroundView.backgroundColor = newValue
        }
    }
    var barTintColor: UIColor? {
        get {
            barView.backgroundColor
        }
        set {
            barView.backgroundColor = newValue
        }
    }
    
    private func config() {
        barView.translatesAutoresizingMaskIntoConstraints = false
        barStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(barStackView)
        contentView.addSubview(titleLabel)
        let titleLabelHeight: CGFloat = Self.titleLabelHeight
        let padding: UIEdgeInsets = Self.padding
        barViewHeightConstraint = barView.heightAnchor.constraint(equalToConstant: .zero)
        barViewWidthConstraint = barView.widthAnchor.constraint(equalToConstant: Self.defaultBarWidth)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.bottom),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight),
            barStackView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -padding.bottom),
            barStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            barStackView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            barStackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
            barStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            barViewHeightConstraint,
            barViewWidthConstraint
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
}

extension BarChartCell {
    static let resuseIdentifier: String = "BarChartCell-UICollectionViewCell"
    static private let titleLabelHeight: CGFloat = 24
    static let defaultBarWidth: CGFloat = 20
    static let padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
}

extension BarChartCell {
    func update(usingData entry: BarChartDataEntry, maxValue: Double) {
        let maxHeight: CGFloat = frame.height - Self.titleLabelHeight - Self.padding.top - Self.padding.bottom
        let ratio: CGFloat = maxHeight/CGFloat(maxValue)
        barViewHeight = CGFloat(entry.value)*ratio
        titleLabel.text = entry.title
        barTintColor = entry.color
    }
}
