//
//  BarChartCell2.swift
//  BarChart
//
//  Created by Nishant Taneja on 13/07/22.
//

import UIKit

class BarChartCell2: BarChartCell {
    let cornerRadius: CGFloat = 4
    
    override func config() {
        super.config()
        barStackView.clipsToBounds = true
        barStackView.backgroundColor = .lightGray
        barStackView.layer.cornerRadius = cornerRadius
        barView.layer.cornerRadius = cornerRadius
    }
}
