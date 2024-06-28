//
//  SecureDataProviderMock.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import Foundation
@testable import PracticaIOSAsincronismo

struct SecureDataProviderMock: SecureDataProtocol {
	let userDefaults = UserDefaults.standard
	let token = "TOKEN"
    
    func setToken(value: String) {
        userDefaults.setValue(value, forKey: token)
    }
    
    func getToken() -> String? {
        userDefaults.value(forKey: token) as? String
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: token)
    }
}
