//
//  NetworkError.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
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
