//
//  NetworkManager.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import Foundation
import Combine

final class NetworkManager {
    enum NetworkError: LocalizedError {
        case invalidResponse
        case httpError(statusCode: Int, url: URL)
        case decodingError(Error)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid server response."
            case let .httpError(statusCode, url):
                return "HTTP Error: \(statusCode) for \(url)"
            case .decodingError(let error):
                return "Decoding Error: \(error.localizedDescription)"
            }
        }
    }
    
    static func execute(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleResponse(output: $0, url: url)})
            .eraseToAnyPublisher()
    }

    private static func handleResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.httpError(statusCode: response.statusCode, url: url)
        }
        return output.data
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
