//
//  NetworkError.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation

enum NetworkError: Error, Equatable {
	case malformedURL
	case dataFormatting
	case other
	case noData
	case unauthorized
	case errorCode(Int?)
	case serverError
	case tokenFormatError
	case decoding
}
