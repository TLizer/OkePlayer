//
//  Double+Extensions.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import Foundation

extension Double {
    func hourMinutesSeconds() -> String {
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int((self / 3600).truncatingRemainder(dividingBy: 60))
        return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
    }
}
