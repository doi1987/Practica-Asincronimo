//
//  String+Utils.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 21/1/24.
//

import Foundation

extension String {
    func getTransformationNumber() -> Int? {
        let splitString = split(separator: ".").first ?? ""
        return Int(splitString)
    }
}
