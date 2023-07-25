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
      case urlInvalid
      case badURLResponse(url: URL)
      case connectionError(error: Error)
      case unknown
    
    var errorDescription: String? {
      switch self {
      case .urlInvalid:
          return "[❌] URL invalid!"
      case .badURLResponse(url: _):
          return "[🔥] Bad response from server."
      case .connectionError(error: let error):
          return "[🛠️] Cannot connect to server! \(error.localizedDescription)"
      case .unknown:
          return  "[⚡] Unknown error occured. Try again!"
      }
    }
  }
    
  // a static func to not initialize this class every time we want to use it
  static func download(url: String) -> AnyPublisher<Data, Error> {
    guard let url = URL(string: url) else {
        return Fail(error: NetworkingError.urlInvalid)//A Fail publisher
            .eraseToAnyPublisher()
    }
      
    return URLSession.shared.dataTaskPublisher(for: url)
      // handle URL errors (most likely not able to connect to the server)
          .mapError({ error -> Error in
              return NetworkingError.connectionError(error: error)
          })
      .tryMap({ try handleURLResponse(output: $0, url: url) })
      .retry(3)// optimization
      .eraseToAnyPublisher()
      // we export the .tryMap content to another static func so it will be cleaner and if we wanted to create second download func we could reuse it.
      //      .tryMap { (output) -> Data in
      //        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
      //          throw URLError(.badServerResponse)
      //        }
      //        return output.data
      //      }
  }
  
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
        throw NetworkingError.badURLResponse(url: url)
      }
      return output.data
  }
    
//    static func handleCompletion(completion: Subscribers.Completion<Error>) {
//        switch completion {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .finished: // default
//                break
//        }
//    }
}
