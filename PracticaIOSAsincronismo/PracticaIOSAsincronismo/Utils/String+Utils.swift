//
//  String+Utils.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

extension String {
    func getTransformationNumber() -> Int? {
        let splitString = split(separator: ".").first ?? ""
        return Int(splitString)
    }
}
