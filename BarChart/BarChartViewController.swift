//
//  BarChartViewController.swift
//  BarChart
//
//  Created by Nishant Taneja on 13/07/22.
//

import UIKit

final class BarChartViewController: UIViewController {
    
    private let barChartView = BarChartView()
    
    private func config() {
        view.backgroundColor = .white
        configBarChartView()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
}


// MARK: - BarChartView

extension BarChartViewController: BarChartViewDataSource {
    private func configBarChartView() {
        barChartView.dataSource = self
        barChartView.barCell = BarChartCell2.self
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView)
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            barChartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            barChartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            barChartView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: DataSource
    
    func dataEntries(forBarChart barChartView: BarChartView) -> [BarChartDataEntry] {
        [
            .init(title: "A", value: 10),
            .init(title: "B", value: 20),
            .init(title: "C", value: 30),
            .init(title: "D", value: 40),
            .init(title: "E", value: 50),
            .init(title: "F", value: 60),
            .init(title: "G", value: 70),
            .init(title: "H", value: 80),
            .init(title: "I", value: 90),
            .init(title: "J", value: 100),
            .init(title: "K", value: 110),
            .init(title: "L", value: 120),
            .init(title: "M", value: 130),
            .init(title: "N", value: 140),
            .init(title: "O", value: 150),
            .init(title: "P", value: 160),
            .init(title: "Q", value: 170),
            .init(title: "R", value: 180),
            .init(title: "S", value: 190),
            .init(title: "T", value: 200),
            .init(title: "U", value: 210),
            .init(title: "V", value: 220),
            .init(title: "W", value: 230),
            .init(title: "X", value: 940),
            .init(title: "Y", value: 2500),
            .init(title: "Z", value: 2600),
        ]
    }
}
