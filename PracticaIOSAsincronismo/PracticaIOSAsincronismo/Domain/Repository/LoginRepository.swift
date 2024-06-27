//
//  LoginRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 25/6/24.
//

import Foundation

protocol LoginRepositoryProtocol {
	func loginWith(email: String, password: String) async -> Result<String,NetworkError>
}

final class LoginRepository: LoginRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}
	
	func loginWith(email: String, password: String) async -> Result<String,NetworkError> {
		await apiProvider.loginWith(email: email, password: password)
	}
}


// MARK: - Fake Succes
final class LoginRepositoryFakeSuccess: LoginRepositoryProtocol {
	func loginWith(email: String, password: String) async -> Result<String, NetworkError> {
		.success("token")
	}
}

// MARK: - Fake Error

final class LoginRepositoryFakeError: LoginRepositoryProtocol {
	func loginWith(email: String, password: String) async -> Result<String, NetworkError> {
		.failure(.noData)
	}
}
