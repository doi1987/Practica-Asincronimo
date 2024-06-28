//
//  Strings+Localized.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

extension String {
	func localized(comment: String = "") -> Self {
		NSLocalizedString(self, comment: comment)
	}
}
