//
//  HomeViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

final class HomeViewModel {
	private let secureDataKeychain: SecureDataProtocol
	
	// MARK: - Binding con UI
	var homeStatusLoad: ((StatusLoad) -> Void)?
	
	// MARK: - Use Case
	let heroUseCase: HeroesUseCaseProtocol
	
	var dataHeroes: [HeroModel] = []
	
	// MARK: - Init
	init(heroUseCase: HeroesUseCaseProtocol = HeroesUseCase(),
		 secureDataKeychain: SecureDataProtocol = SecureDataKeychain()) {
		self.heroUseCase = heroUseCase
		self.secureDataKeychain = secureDataKeychain
	}
	
	// MARK: - GetHeroes
	func loadHeroes() {
		homeStatusLoad?(.loading)
		
		heroUseCase.getHeroes { [weak self] heroes in
			DispatchQueue.main.async {
				self?.dataHeroes = heroes.sorted()
				self?.homeStatusLoad?(.loaded)
			}
		} onError: { [weak self] networkError in
			DispatchQueue.main.async {
				self?.homeStatusLoad?(.error(error: networkError))
			}
		}
	}
	
	func logout() {
		secureDataKeychain.deleteToken()
	}
}
