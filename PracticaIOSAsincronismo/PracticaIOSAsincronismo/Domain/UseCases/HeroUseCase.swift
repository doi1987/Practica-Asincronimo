//
//  HomeUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

protocol HomeUseCaseProtocol {
	func getHeroes(name: String) async -> Result<[HeroModel],NetworkError>
}

final class HomeUseCase: HomeUseCaseProtocol {
	private let homeRepository: HomeRepositoryProtocol
	
	init(homeRepository: HomeRepositoryProtocol = HomeRepository()) {
		self.homeRepository = homeRepository
	}
	
	func getHeroes(name: String) async -> Result<[HeroModel], NetworkError> {		
		await homeRepository.getHeroesWith(name: name)
	}	
}

// MARK: - Fake Succes
final class HomeUseCaseFakeSuccess: HomeUseCaseProtocol {
	func getHeroes(name: String) async -> Result<[HeroModel], NetworkError> {
		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		return .success(heroes)
	}
}

// MARK: - Fake Error

final class HomeUseCaseFakeError: HomeUseCaseProtocol {
	func getHeroes(name: String) async -> Result<[HeroModel], NetworkError> {
		.failure(.serverError)
		
	}
}
