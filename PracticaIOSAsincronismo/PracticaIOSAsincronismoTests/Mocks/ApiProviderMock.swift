//
//  ApiProviderMock.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import Foundation
@testable import PracticaIOSAsincronismo

class ApiProviderMock: ApiProviderProtocol {
	var login: Result<String, NetworkError> = .success("token")
	var heroes: Result<[HeroModel], NetworkError> = .success([HeroModel(id: "1",
																		name: "Diego",
																		description: "Superman",
																		photo: "",
																		favorite: true)])
	var transformations: Result<[TransformationModel],
								NetworkError> = .success([TransformationModel(id: "id",
																			  name: "Kaioken",
																			  description: "des",
																			  photo: nil)])
	
	func loginWith(email: String, password: String) async -> Result<String, NetworkError> {
		login
	}
	
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError> {
		heroes
	}
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		transformations
	}
}
