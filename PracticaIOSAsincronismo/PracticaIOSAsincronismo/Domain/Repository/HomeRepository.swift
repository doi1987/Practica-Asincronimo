//
//  HomeRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 25/6/24.
//

import Foundation

protocol HomeRepositoryProtocol {
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError>
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
}

final class HomeRepository: HomeRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}	
	
	func getHeroesWith(name: String) async -> Result<[HeroModel],NetworkError> {
		await apiProvider.getHeroesWith(name: name)
	}
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		await apiProvider.getTransformationsForHeroWith(id: id)
	}
}
