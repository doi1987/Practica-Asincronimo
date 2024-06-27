//
//  HeroDetailUseCases.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

protocol TransformationsUseCaseProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
}

final class TransformationsUseCase: TransformationsUseCaseProtocol {	
	private let transformationsRepository: TransformationsRepositoryProtocol
	
	init(transformationsRepository: TransformationsRepositoryProtocol = TransformationsRepository()) {
		self.transformationsRepository = transformationsRepository
	}
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		await transformationsRepository.getTransformationsForHeroWith(id: id)
	}
}

// MARK: - Fake Success
final class TransformationsUseCaseFakeSuccess: TransformationsUseCaseProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		let transformations = [TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)]
			return .success(transformations)
		
	}
}

// MARK: - Fake Error
final class TransformationsUseCaseFakeError: TransformationsUseCaseProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		.failure(.serverError)
	}
}
