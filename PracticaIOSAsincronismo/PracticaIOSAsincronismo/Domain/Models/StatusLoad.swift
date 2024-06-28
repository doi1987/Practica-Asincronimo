//
//  StatusLoad.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

enum StatusLoad: Equatable {
	case loading
	case loaded
	case error(error: NetworkError)
}
