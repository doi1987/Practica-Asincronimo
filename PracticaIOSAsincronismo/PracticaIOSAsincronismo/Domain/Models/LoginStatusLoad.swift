//
//  LoginStatusLoad.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

enum LoginStatusLoad {
	case loading(_ loading: Bool) 
	case loaded
	case showErrorEmail(_ error: String?)
	case showErrorPassword(_ error: String?)
	case errorNetwork(_ error: String)
}
