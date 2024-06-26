//
//  HeroDetailViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

final class HeroDetailViewModel {

	@Published var heroDetailStatusLoad: StatusLoad?
	private let heroDetailUseCase: HeroDetailUseCaseProtocol
	private var hero: HeroModel
	@Published var dataTransformations: [TransformationModel] = .init()
//	private var error: NetworkError?
	
	init(hero: HeroModel,
		 heroDetailUseCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
		self.hero = hero
		self.heroDetailUseCase = heroDetailUseCase
	}
	
	func loadDetail() {
		heroDetailStatusLoad = .loading
		loadTransformations(heroId: hero.id)
//		updateState()
	}
	
	func getHero() -> HeroModel? {
		hero
	}
	
	func getTransformations() -> [TransformationModel] {
		self.dataTransformations
	}
	
	func heroNameAndId() -> (name: String?, id: String?) {
		(hero.name, hero.id)
	}
}

private extension HeroDetailViewModel {
	func loadTransformations(heroId: String) {
		Task{
			let result = await heroDetailUseCase.getTransformationsForHeroWith(id: heroId)
			switch result {
			case .success(let transformations):
				dataTransformations = transformations.sorted()
				heroDetailStatusLoad = .loaded
			case .failure(let error):
				heroDetailStatusLoad = .error(error: error)
			}
		}
	}
}
//	func updateState() {
//		group.notify(queue: .main) {
//			DispatchQueue.main.async { [weak self] in
//				guard let error = self?.error else { 
//					self?.heroDetailStatusLoad?(.loaded)
//					return
//				}
//				
//				self?.heroDetailStatusLoad?(.error(error: error))
//			}
//		}
//	}
//}
//
//enum HeroDetailStatusLoad: Equatable {
//	case loading
//	case loaded
//	case error(error: NetworkError)
//	case none
//}
