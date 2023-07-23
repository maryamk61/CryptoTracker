//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/28/1401 AP.
//

import Foundation
import Combine

class NetworkingManager {
  
  enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
      switch self {
      case .badURLResponse(url: let url):
          return "[🔥] Bad response from URL. \(url)"
      case .unknown:
          return  "[⚡] Unknown error occured."
      }
    }
  }
  // a static func to not initialize this class every time we want to use it
  static func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
    // we export the .tryMap content to another static func so it will be cleaner and if we wanted to create second download func we could reuse it.
//      .tryMap { (output) -> Data in
//        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
//          throw URLError(.badServerResponse)
//        }
//        return output.data
//      }
      .tryMap({ try handleURLResponse(output: $0, url: url) })
      .retry(3)// optimization
      .eraseToAnyPublisher()
  }
  
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
//        throw URLError(.badServerResponse)
        print("Status code >>>> \(output.response)")
        throw NetworkingError.badURLResponse(url: url)
      }
      return output.data
  }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished: // default
                break
        }
    }
}
