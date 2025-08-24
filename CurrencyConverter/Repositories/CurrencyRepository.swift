//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 24/8/25.
//

import Alamofire
import Foundation

protocol CurrencyRepositoryDelegate: AnyObject { // TODO: why we set AnyObject
    func fetchLatestRates() async throws -> CurrencyResponseg
    func getAvailableCurrencies() -> [Currency]
}

class CurrencyRepository: CurrencyRepositoryDelegate {
    private let baseCurrency: String
    
    init(baseCurrency: String = "USD") {
        self.baseCurrency = baseCurrency
    }
    
    func getAvailableCurrencies() -> [Currency] {
        return dummyCurrencies
    }
    
    func fetchLatestRates() async throws -> CurrencyResponse {
        let url = AppConfig.baseUrl + "/" + AppConfig.apiVersion + "/" + AppConfig.apiKey + "/"
        return try await withCheckedThrowingContinuation { continuation in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request("\(url)latest/\(baseCurrency)")
                .responseDecodable(of: CurrencyResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let currencies):
                        continuation.resume(returning: currencies)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
