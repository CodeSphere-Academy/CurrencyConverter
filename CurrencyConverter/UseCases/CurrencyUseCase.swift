//
//  CurrencyUseCase.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 24/8/25.
//

import Alamofire
import Foundation
// ViewModel > UseCase > Repository > networking
protocol CurrencyUseCaseDelegate: AnyObject {
    func convertCurrency(amount: Double, from: String, to: String) async -> Double
    func fetchLatestRates(baseCurrency: String) async throws -> [String: Double]
    func getAvailableCurrencies() async throws -> [Currency]
    func swapCurrencies(from: Currency?, to: Currency?) -> (from: Currency?, to: Currency?)
}

class CurrencyUseCase: CurrencyUseCaseDelegate {
    private let repository: CurrencyRepositoryDelegate
    private var baseCurrency: String = ""
    private var cache: [String: Double] = [:]
    init(repository: CurrencyRepositoryDelegate = CurrencyRepository()) {
        self.repository = repository
    }
    
    func convertCurrency(amount: Double, from: String, to: String) async -> Double {
        return 0.0
    }
    
    func fetchLatestRates(baseCurrency: String) async throws -> [String: Double] {
        let response = try await repository.fetchLatestRates()
        cache = response.conversionRates
        return response.conversionRates
    }
    
    func getAvailableCurrencies() async throws -> [Currency] {
        return try await repository.getAvailableCurrencies()
    }
    
    func swapCurrencies(from: Currency?, to: Currency?) -> (from: Currency?, to: Currency?) {
        (from: to, to: from)
    }
}
