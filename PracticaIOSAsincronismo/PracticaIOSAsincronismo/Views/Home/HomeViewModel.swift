//
//  HomeViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

final class HomeViewModel {
	private let secureDataKeychain: SecureDataProtocol
	
	@Published var homeStatusLoad: StatusLoad?
	
	private let homeUseCase: HomeUseCaseProtocol
	var dataHeroes: [HeroModel] = []
	
	init(homeUseCase: HomeUseCaseProtocol = HomeUseCase(),
		 secureDataKeychain: SecureDataProtocol = SecureDataKeychain()) {
		self.homeUseCase = homeUseCase
		self.secureDataKeychain = secureDataKeychain
	}
	
	func loadHeroes() {
		homeStatusLoad = .loading
		
		Task{
			let result = await homeUseCase.getHeroes(name: "")
			switch result {
			case .success(let heroes):
				dataHeroes = heroes.sorted()
				homeStatusLoad = .loaded
				
			case .failure(let error):
				homeStatusLoad = .error(error: error)
			}
		}
	}
	
	func logout() {
		secureDataKeychain.deleteToken()
	}
}
