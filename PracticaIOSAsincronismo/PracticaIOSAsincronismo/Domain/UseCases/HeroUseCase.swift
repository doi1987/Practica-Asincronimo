//
//  HeroUseCase.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import Foundation

protocol HeroUseCaseProtocol {
	func getHeroes(name: String) async -> Result<[HeroModel],NetworkError>
}

final class HeroUseCase: HeroUseCaseProtocol {
	private let heroRepository: HeroRepositoryProtocol
	
	init(heroRepository: HeroRepositoryProtocol = HeroRepository()) {
		self.heroRepository = heroRepository
	}
	
	func getHeroes(name: String) async -> Result<[HeroModel], NetworkError> {		
		await heroRepository.getHeroesWith(name: name)
	}	
}

// MARK: - HeroUseCaseMock
final class HeroUseCaseMock: HeroUseCaseProtocol {
	var result: Result<[HeroModel], NetworkError> = .success([HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true),
															  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
								HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)])

	func getHeroes(name: String) async -> Result<[HeroModel], NetworkError> {
		result
	}
}
