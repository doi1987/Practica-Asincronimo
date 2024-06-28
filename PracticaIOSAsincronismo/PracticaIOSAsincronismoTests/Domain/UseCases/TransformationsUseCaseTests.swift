//
//  TransformationsUseCaseTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 28/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class TransformationsUseCaseTests: XCTestCase {
	private var sut: TransformationsUseCaseProtocol!
	private var transformationsRepositoryMock: TransformationsRepositoryMock = TransformationsRepositoryMock()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = TransformationsUseCase(transformationsRepository: transformationsRepositoryMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenNoNameWhenGetHeroesThenSuccessMatch() async throws {
		let expectedTransformations = [TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)]
		
		transformationsRepositoryMock.result = .success(expectedTransformations)
		
		let heroId = "random"
		let result = await sut.getTransformationsForHeroWith(id: heroId)

		switch result {
		case .success(let transformations):
			XCTAssertEqual(transformations.count, 1)
			XCTAssertEqual(transformations, expectedTransformations)
		case .failure:
			XCTFail("Expected success but got failure")
		}
	}
	
	func testGivenNoNameWhenGetHeroesThenErrorMatch() async throws {
		
		transformationsRepositoryMock.result = .failure(.decoding)
		let result = await sut.getTransformationsForHeroWith(id: "")
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .decoding)
		}
	}
}
