//
//  HeroDetailUseCases.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

protocol  HeroDetailUseCaseProtocol {
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
//	func getHeroDetail(name: String, 
//					   onSuccess: @escaping ([HeroModel]) -> Void, 
//					   onError: @escaping (NetworkError) -> Void)
}

final class HeroDetailUseCase: HeroDetailUseCaseProtocol {	
	private let heroDetailRepository: HeroDetailRepositoryProtocol
	
	init(heroDetailRepository: HeroDetailRepository = HeroDetailRepository()) {
		self.heroDetailRepository = heroDetailRepository
	}
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		let result = await heroDetailRepository.getTransformationsForHeroWith(id: id)
		switch result {
		case .success(let transformations):
			return .success(transformations)
		case .failure(let error):
			return .failure(error)
		}
	}
//	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
//		apiProvider.getHeroesWith(name: name, completion: { completion in
//			switch completion {
//			case .success(let transformations):
//				onSuccess(transformations)
//			case .failure(let error):
//				onError(error)
//			}
//		})
	
}

//// MARK: - Fake Success
//final class HeroDetailUseCaseFakeSuccess: HeroDetailUseCaseProtocol {
//	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
//		let hero = [HeroModel(id: "1", name: name, description: "Superman", photo: "", favorite: true)]
//		onSuccess(hero)
//		
//	}
//}
//
//// MARK: - Fake Error
//final class HeroDetailUseCaseFakeError: HeroDetailUseCaseProtocol {
//	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
//		onError(.malformedURL)
//	}
//}
