//
//  LoginViewModel.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
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
		guard let email = email, let password = password else { return }
		
		var emailValid: Bool = true
		var passValid: Bool = true
		
		if !isValid(email: email)  {
			loginState = .showErrorEmail("Email error".localized())
			emailValid = false
		} else {
			loginState = .showErrorEmail(nil)
		}
		
		if !isValid(password: password) {
			loginState = .showErrorPassword("Password error".localized())
			passValid = false
		} else {
			loginState = .showErrorPassword(nil)
		}
		
		guard emailValid, passValid else { return }
		
		loginWith(email: email, password: password)
	}
	
	func isValid(email: String) -> Bool {
		loginUseCase.isValid(email: email)
	}
	

	func isValid(password: String) -> Bool {
		loginUseCase.isValid(password: password)
	}
}
