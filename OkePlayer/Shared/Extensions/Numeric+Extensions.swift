//
//  Numeric+Extensions.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 23/11/2020.
//

import Foundation

extension Numeric where Self: Comparable {
    func clamped(minValue: Self, maxValue: Self) -> Self {
        min(maxValue, max(minValue, self))
    }
}
