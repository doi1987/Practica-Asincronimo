//
//  HeroDetailViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

final class HeroDetailViewModel {
	@Published var heroDetailStatusLoad: StatusLoad?
	private let transformationsUseCase: TransformationsUseCaseProtocol
	private let hero: HeroModel
	private var dataTransformations: [TransformationModel] = []
	
	init(hero: HeroModel,
		 transformationsUseCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
		self.hero = hero
		self.transformationsUseCase = transformationsUseCase
	}
	
	func loadTransformations() {
		heroDetailStatusLoad = .loading
		loadTransformations(heroId: hero.id)
	}
	
	func getHero() -> HeroModel? {
		hero
	}
	
	func getTransformations() -> [TransformationModel] {
		dataTransformations
	}
	
	func heroNameAndId() -> (name: String?, id: String?) {
		(hero.name, hero.id)
	}
}

private extension HeroDetailViewModel {
	func loadTransformations(heroId: String) {
		Task {
			let result = await transformationsUseCase.getTransformationsForHeroWith(id: heroId)
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
