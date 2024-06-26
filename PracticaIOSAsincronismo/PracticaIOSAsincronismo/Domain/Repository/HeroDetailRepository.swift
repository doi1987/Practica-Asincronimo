//
//  HeroDetailRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 26/6/24.
//

import Foundation

protocol HeroDetailRepositoryProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
}

final class HeroDetailRepository: HeroDetailRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}	
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		await apiProvider.getTransformationsForHeroWith(id: id)
	}
}
