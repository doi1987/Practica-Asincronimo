//
//  LoginUseCase.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 25/6/24.
//

import Foundation

protocol LoginUseCaseProtocol {
	func loginWith(email: String, password: String) async -> Result<String,NetworkError>
	func isValid(password: String) -> Bool
	func isValid(email: String) -> Bool
}

final class LoginUseCase: LoginUseCaseProtocol {
	private let loginRepository: LoginRepository
	
	init(loginRepository: LoginRepository = LoginRepository()) {
		self.loginRepository = loginRepository
	}
	
	func loginWith(email: String, password: String) async -> Result<String,NetworkError> {
		let result = await loginRepository.loginWith(email: email, password: password)
		switch result {
		case .success(let token):
			SecureDataKeychain.shared.setToken(value: token)
			return .success(token)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	// Check email
	func isValid(email: String) -> Bool {
		email.isEmpty == false && email.contains("@")
	}
	
	// Check password
	func isValid(password: String) -> Bool {
		password.isEmpty == false && password.count >= 4
	}
}
