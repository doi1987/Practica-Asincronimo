//
//  HeroRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 25/6/24.
//

import Foundation

protocol HeroRepositoryProtocol {
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError>
}

final class HeroRepository: HeroRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}	
	
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError> {
		await apiProvider.getHeroesWith(name: name)
	}
}

// MARK: - HeroRepositoryMock
final class HeroRepositoryMock: HeroRepositoryProtocol {
	var result: Result<[HeroModel], NetworkError> = .success([HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
															  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
															  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)])
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError> {
		result
	}
}
