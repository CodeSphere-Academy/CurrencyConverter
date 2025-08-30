//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 24/8/25.
//

import Alamofire
import Foundation

protocol CurrencyRepositoryDelegate: AnyObject {
    func fetchLatestRates() async throws -> CurrencyResponse
    func getAvailableCurrencies() async throws -> [Currency]
}

class CurrencyRepository: CurrencyRepositoryDelegate {
    // Mapper work in repository
    private let baseCurrency: String
    private let currencyBaseUrl = AppConfig.baseUrl + "/" + AppConfig.apiVersion + "/" + AppConfig.apiKey
    init(baseCurrency: String = "USD") {
        self.baseCurrency = baseCurrency
    }
    
    private func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func getAvailableCurrencies() async throws -> [Currency] {
        return try await withCheckedThrowingContinuation { continuation in
            // TODO: separate into networking services
            AF.request(currencyBaseUrl + "/codes")
                .responseDecodable(of: CurrencyCodeResponse.self, decoder: getDecoder()) { response in
                    switch response.result {
                    case .success(let codes):
                        continuation.resume(returning: CurrencyCodeMapper().map(input: codes))
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchLatestRates() async throws -> CurrencyResponse {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("\(currencyBaseUrl)/latest/\(baseCurrency)")
                .responseDecodable(of: CurrencyResponse.self, decoder: getDecoder()) { response in
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
