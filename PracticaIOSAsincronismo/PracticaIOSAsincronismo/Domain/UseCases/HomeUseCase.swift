//
//  HomeUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

protocol HomeUseCaseProtocol {
	func getHeroes(name: String) async -> Result<[HeroModel],NetworkError>
}

final class HomeUseCase: HomeUseCaseProtocol {
	private let homeRepository: HomeRepositoryProtocol
	
	init(homeRepository: HomeRepositoryProtocol = HomeRepository()) {
		self.homeRepository = homeRepository
	}
	
	func getHeroes(name: String) async -> Result<[HeroModel],NetworkError> {		
		let result = await homeRepository.getHeroesWith(name: name)
		switch result {
		case .success(let heroes):
			return .success(heroes)
		case .failure(let error):
			return .failure(error)
		}
	}	
}

//// MARK: - Fake Succes
//final class HeroesUseCaseFakeSuccess: HeroesUseCaseProtocol {
//	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
//		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
//					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
//					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
//		onSuccess(heroes)
//	}
//}
//
//// MARK: - Fake Error
//
//final class HeroesUseCaseFakeError: HeroesUseCaseProtocol {
//	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
//		onError(.noData)
//		
//	}
//}
