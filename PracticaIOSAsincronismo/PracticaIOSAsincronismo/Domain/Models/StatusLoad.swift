//
//  SplashStatusLoad.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation

enum StatusLoad: Equatable {
	case loading
	case loaded
	case error(error: NetworkError)
	case none
}
