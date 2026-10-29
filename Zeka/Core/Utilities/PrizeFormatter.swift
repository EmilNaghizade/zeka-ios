//
//  PrizeFormatter.swift
//  Zeka
//
//  Created by admin on 29.10.26.
//

import Foundation

enum PrizeFormatter {
    static func string(from amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3

        let number = formatter.string(
            from: NSNumber(value: amount)
        ) ?? "\(amount)"

        return "\(number) ₼"
    }
}

