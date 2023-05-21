//
//  NetoworkManger.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 16/05/2023.
//

import Foundation
import Combine

class NetworkManger{
    
    enum NetworkingError:LocalizedError{
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badUrlResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url:URL)-> AnyPublisher<Data,Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ element-> Data in
                guard let response = element.response as? HTTPURLResponse,(200...299).contains(response.statusCode)  else{
                    throw NetworkingError.badUrlResponse(url: url)//URLError(.badServerResponse)
                }
                return element.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
   
}
