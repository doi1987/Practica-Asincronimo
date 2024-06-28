//
//  HomeViewModel.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

final class HomeViewModel {
	private let secureDataKeychain: SecureDataProtocol
	
	@Published var homeStatusLoad: StatusLoad?
	
	private let heroUseCase: HeroUseCaseProtocol
	var dataHeroes: [HeroModel] = []
	
	init(heroUseCase: HeroUseCaseProtocol = HeroUseCase(),
		 secureDataKeychain: SecureDataProtocol = SecureDataKeychain.shared) {
		self.heroUseCase = heroUseCase
		self.secureDataKeychain = secureDataKeychain
	}
	
	func loadHeroes() {
		homeStatusLoad = .loading
		
		Task{
			let result = await heroUseCase.getHeroes(name: "")
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
