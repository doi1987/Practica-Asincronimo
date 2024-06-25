//
//  HomeUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

	// MARK: - Protocolo Home
protocol HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}
	
	// MARK: - CLase homeUseCase
final class HeroesUseCase: HeroesUseCaseProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}
	
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {		
		apiProvider.getHeroesWith(name: "", completion: { [weak self] completion in
			switch completion {
			case .success(let heroes):
				onSuccess(heroes)
			case .failure(let error):
				onError(error)
			}
		})
		
	}
}

// MARK: - Fake Succes
final class HeroesUseCaseFakeSuccess: HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		onSuccess(heroes)
	}
}

// MARK: - Fake Error

final class HeroesUseCaseFakeError: HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		onError(.noData)
		
	}
}
