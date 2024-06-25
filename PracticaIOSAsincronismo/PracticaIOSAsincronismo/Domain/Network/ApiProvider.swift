//
//  ApiProvider.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

// Endpoints de la api
enum Endpoints {
	case login
	case heroes
	case transformations
	case locations
	
	func endpoint() -> String {
		switch self {
		case .login:
			return "api/auth/login"
		case .heroes:
			return "api/heros/all"
		case .transformations:
			return "api/heros/tranformations"
		case .locations:
			return "api/heros/locations"
		}
	}
	
	func httpMethod() -> String {
		switch self {
		case .login, .heroes, .transformations, .locations:
			return "POST"
		}
	}
}


// Crea request para un endpoint dado
struct RequestProvider {
	let host = URL(string: "https://dragonball.keepcoding.education")!
	
	func requestFor(endpoint: Endpoints) -> URLRequest {
		let url = host.appendingPathComponent(endpoint.endpoint())
		var request = URLRequest.init(url: url)
		request.httpMethod = endpoint.httpMethod()
		return request
	}
	
	func requestFor(endpoint: Endpoints, token:String, params: [String: Any]) -> URLRequest {
		
		var request = self.requestFor(endpoint: endpoint)
		let jsonParameters = try? JSONSerialization.data(withJSONObject: params)
		request.httpBody = jsonParameters
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		
		return request
	}
}

protocol ApiProviderProtocol {
	func loginWith(email: String, password: String) async -> Result<String, NetworkError>
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError>
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError>
	
}

class ApiProvider: ApiProviderProtocol {
	private var session: URLSession
	private var requestProvider: RequestProvider
	
	init(session: URLSession = URLSession.shared,
		 requestProvider: RequestProvider = RequestProvider()) {
		self.session = session
		self.requestProvider = requestProvider
	}
	
	
	// Llamada al servicio login
	func loginWith(email: String, password: String) async -> Result<String, NetworkError> {
		guard let loginData = String(format: "%@:%@", email, password).data(using: .utf8)?.base64EncodedString() else {
			return .failure(.dataFormatting)
		}
		
		var request = requestProvider.requestFor(endpoint: .login)
		request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
		
		do {
			let token: String = try await makeRequestfor(request: request)
			return .success(token)
			
		} catch(let error) {
			if let error = error as? NetworkError {
				return .failure(error)
			} else {
				return .failure(.other)
			}
		}
	}
	
	func getHeroesWith(name: String) async -> Result<[HeroModel], NetworkError> {
		guard let token = SecureDataKeychain.shared.getToken() else {
			return .failure(.tokenFormatError)
		}
		
		let request = requestProvider.requestFor(endpoint: .heroes, token: token, params: ["name": name])
		
		do{
			let result: [HeroModel] = try await makeDataRequestfor(request: request)
			return .success(result)
		} catch(let error) {
			if let error = error as? NetworkError {
				return .failure(error)
			} else {
				return .failure(.other)
			}		
		}
	}
	
	func getTransformationsForHeroWith(id: String) async -> Result<[TransformationModel], NetworkError> {
		guard let token = SecureDataKeychain.shared.getToken() else {
			return .failure(.tokenFormatError)
		}
		
		let request = requestProvider.requestFor(endpoint: .transformations, token: token, params: ["id": id])
		do{
			let result: [TransformationModel] = try await makeDataRequestfor(request: request)
			return .success(result)
		} catch(let error) {
			if let error = error as? NetworkError {
				return .failure(error)
			} else {
				return .failure(.other)
			}		
		}
	}
}

extension ApiProvider {
	
	func makeRequestfor(request: URLRequest) async throws -> String {
		
		let (data, response) = try await session.data(for: request) 
		
		guard let response = response as? HTTPURLResponse else {
			throw NetworkError.serverError
		}
		
		guard response.statusCode != 500 else { 
			throw NetworkError.serverError
		}
		
		guard response.statusCode != 401 else { 
			throw NetworkError.unauthorized
		}
		
		if let token = String(data: data, encoding: .utf8) {
			SecureDataKeychain.shared.setToken(value: token)
			return token
		} else {
			throw NetworkError.tokenFormatError
		}
	}
	
	func makeDataRequestfor<T: Decodable>(request: URLRequest) async throws -> [T] {
		
		let (data, response) = try await session.data(for: request)
		
		guard let response = response as? HTTPURLResponse else {
			throw NetworkError.serverError
		}
		
		guard response.statusCode != 500 else { 
			throw NetworkError.serverError
		}
		
		guard response.statusCode != 401 else { 
			throw NetworkError.unauthorized
		}
		
		let dataReceived = try JSONDecoder().decode([T].self, from: data) 
		return dataReceived	
	}
}


