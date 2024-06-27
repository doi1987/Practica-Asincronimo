//
//  HeroDetailRepository.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 26/6/24.
//

import Foundation

protocol TransformationsRepositoryProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
}

final class TransformationsRepository: TransformationsRepositoryProtocol {
	private let apiProvider: ApiProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider()) {
		self.apiProvider = apiProvider
	}	
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		await apiProvider.getTransformationsForHeroWith(id: id)
	}
}

// MARK: - Fake Success
final class TransformationsRepositoryFakeSuccess: TransformationsRepositoryProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		let transformations = [TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)]
			return .success(transformations)
	}
}

// MARK: - Fake Error

final class TransformationsRepositoryFakeError: TransformationsRepositoryProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		.failure(.noData)
	}
}
