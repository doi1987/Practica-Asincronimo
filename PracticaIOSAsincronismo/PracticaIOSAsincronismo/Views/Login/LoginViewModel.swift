//
//  LoginViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation
import Combine

enum LoginState: Equatable {
	case loading
	case success
	case failed(_ error: NetworkError)
	case showErrorEmail(_ error: String?)
	case showErrorPassword(_ error: String?)
}

final class LoginViewModel {
	
	private let loginUseCase: LoginUseCaseProtocol
	
	@Published var loginState: LoginState?
	
	init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
		self.loginUseCase = loginUseCase
	}
	
	func loginWith(email: String, password: String) {
		loginState = .loading
		
		Task {
			let result = await loginUseCase.loginWith(email: email, password: password) 
			switch result {
			case .success(_):
				loginState = .success
				
			case .failure(let error):
				loginState = .failed(error)
			}
		}
	}
	
	func onLoginButton(email: String?, password: String?) {
		loginState = .loading
		
		Task {
			guard let email = email, isValid(email: email) else {
				loginState = .showErrorEmail("Email error")
				return
			}
			
			guard let password = password, isValid(password: password) else {
				loginState = .showErrorPassword("Password error")
				return
			}
			
			loginWith(email: email, password: password)
		}
	}
	
	func isValid(email: String) -> Bool {
		loginUseCase.isValid(email: email)
	}
	

	func isValid(password: String) -> Bool {
		loginUseCase.isValid(password: password)
	}
}
