//
//  TransformationsRepository.swift
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

// MARK: - TransformationsRepositoryMock
final class TransformationsRepositoryMock: TransformationsRepositoryProtocol {
	var result: Result<[TransformationModel], NetworkError> = .success([TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)])
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		result
	}
}
