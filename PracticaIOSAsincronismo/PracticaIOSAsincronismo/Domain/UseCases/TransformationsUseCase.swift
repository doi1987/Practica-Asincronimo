//
//  TransformationslUseCases.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
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

// MARK: - TransformationsUseCaseMock
final class TransformationsUseCaseMock: TransformationsUseCaseProtocol {
	var result: Result<[TransformationModel], NetworkError> = .success([TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)])
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		result
	}
}
