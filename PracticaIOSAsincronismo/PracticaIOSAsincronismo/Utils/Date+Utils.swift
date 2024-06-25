//
//  Date+Utils.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 14/6/24.
//

import Foundation

extension Date {
	func toDayMonthYear() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy"
		return formatter.string(from: self)
	}
}

extension DateFormatter {
	static let formatDate: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "es_Es")
		return formatter
	}()
}
