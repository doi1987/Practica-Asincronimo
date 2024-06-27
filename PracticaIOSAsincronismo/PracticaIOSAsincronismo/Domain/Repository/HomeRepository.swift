//
//  HomeRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 25/6/24.
//

import Foundation

protocol HomeRepositoryProtocol {
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError>
}

final class HomeRepository: HomeRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}	
	
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError> {
		await apiProvider.getHeroesWith(name: name)
	}
}

// MARK: - Fake Success
final class HomeRepositoryFakeSuccess: HomeRepositoryProtocol {
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError> {
		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		return .success(heroes)
	}
}

// MARK: - Fake Error

final class HomeRepositoryFakeError: HomeRepositoryProtocol {
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError> {
		.failure(.noData)
	}
}
