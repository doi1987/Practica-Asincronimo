//
//  TransformationsRepositoryTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 28/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class TransformationsRepositoryTests: XCTestCase {
	private var sut: TransformationsRepositoryProtocol!
	private let apiProviderMock: ApiProviderMock = .init()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = TransformationsRepository(apiProvider: apiProviderMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenAHeroIdWhenGetTransformationsThenSuccessMatch() async throws {
		let expectedTransformations = [TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)]
		
		apiProviderMock.transformations = .success(expectedTransformations)
		
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
	
	func testGivenAHeroIdWhenGetTransformationsThenErrorMatch() async throws {
		apiProviderMock.transformations = .failure(.noData)
		let result = await sut.getTransformationsForHeroWith(id: "")
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .noData)
		}
	}
}

