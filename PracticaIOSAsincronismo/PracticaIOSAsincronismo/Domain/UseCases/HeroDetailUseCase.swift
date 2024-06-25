//
//  HeroDetailUseCases.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

// MARK: - Protocolo Hero
protocol  HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, 
					   onSuccess: @escaping ([HeroModel]) -> Void, 
					   onError: @escaping (NetworkError) -> Void)
}

// MARK: - Clase Hero Use Case
final class HeroDetailUseCase: HeroDetailUseCaseProtocol {	
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}
	
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		apiProvider.getHeroesWith(name: name, completion: { completion in
			switch completion {
			case .success(let transformations):
				onSuccess(transformations)
			case .failure(let error):
				onError(error)
			}
		})
	}
}

// MARK: - Fake Succes
final class HeroDetailUseCaseFakeSuccess: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let hero = [HeroModel(id: "1", name: name, description: "Superman", photo: "", favorite: true)]
		onSuccess(hero)
		
	}
}

// MARK: - Fake Error
final class HeroDetailUseCaseFakeError: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		onError(.malformedURL)
	}
}
