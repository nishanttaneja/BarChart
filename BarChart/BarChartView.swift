//
//  BarChartView.swift
//  BarChart
//
//  Created by Nishant Taneja on 13/07/22.
//

import UIKit

protocol BarChartViewDataSource: NSObjectProtocol {
    func dataEntries(forBarChart barChartView: BarChartView) -> [BarChartDataEntry]
}

final class BarChartView: UIView {
    private var collectionView: UICollectionView!
    
    weak var dataSource: BarChartViewDataSource? = nil {
        didSet {
            let entries = dataSource?.dataEntries(forBarChart: self) ?? []
            maxValueEntry = entries.max(by: { $1.value > $0.value })
            self.entries = entries
            let estimatedBarWidth = getEstimatedBarWidth()
            self.estimatedBarWidth = estimatedBarWidth > .zero ? estimatedBarWidth : BarChartCell.defaultBarWidth
        }
    }
    
    private(set) var entries: [BarChartDataEntry] = []
    private var maxValueEntry: BarChartDataEntry? = nil
    private var estimatedBarWidth: CGFloat = BarChartCell.defaultBarWidth
    var shouldUseEstimatedBarWidth: Bool = true
    var barWidth: CGFloat = 20 {
        willSet {
            estimatedBarWidth = barWidth
        }
    }
    var barCell: BarChartCell.Type = BarChartCell.self {
        willSet {
            collectionView.register(newValue.self, forCellWithReuseIdentifier: newValue.resuseIdentifier)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let estimatedBarWidth = getEstimatedBarWidth()
        self.estimatedBarWidth = estimatedBarWidth > .zero ? estimatedBarWidth : BarChartCell.defaultBarWidth
    }
    
    private func config() {
        configCollectionView()
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


// MARK: - CollectionView

extension BarChartView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var cellReuseIdentifier: String {
        barCell.resuseIdentifier
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 2
        return flowLayout
    }
    
    private func configCollectionView() {
        let collectionViewLayout = getCollectionViewLayout()
        collectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BarChartCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let barChartCell = cell as? BarChartCell, entries.count > indexPath.item else { return cell }
        let maxValue: Double = maxValueEntry?.value ?? .zero
        barChartCell.barWidth = shouldUseEstimatedBarWidth ? estimatedBarWidth : barWidth
        barChartCell.shouldUseEstimatedWidth = shouldUseEstimatedBarWidth
        barChartCell.update(usingData: entries[indexPath.item], maxValue: maxValue)
        return barChartCell
    }
    
    // MARK: Delegate
    
    private func getEstimatedBarWidth() -> CGFloat {
        let cellPadding: UIEdgeInsets = BarChartCell.padding
        let lineSpacing: CGFloat = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? .zero
        let fullWidth: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - cellPadding.left - cellPadding.right - (CGFloat(entries.count)*lineSpacing)
        let estimatedWidth: CGFloat = fullWidth/CGFloat(entries.count)
        return estimatedWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetHeight: CGFloat = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        let estimatedWidth: CGFloat = shouldUseEstimatedBarWidth ? estimatedBarWidth : barWidth
        return CGSize(width: estimatedWidth, height: targetHeight)
    }
}
