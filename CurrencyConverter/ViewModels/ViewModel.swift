//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 23/8/25.
//

import Alamofire
import Foundation

@MainActor
class ViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var convertedAmount: String = ""
    // MARK: - Currency exchange
    @Published var fromCurrency: Currency?
    @Published var toCurrency: Currency?
    private let useCase: CurrencyUseCaseDelegate
    @Published var supportedCurrencies: [Currency] = []
    var currencyRates = [String: Double]()
    
    init(useCase: CurrencyUseCaseDelegate = CurrencyUseCase()) {
        self.useCase = useCase
    }
    
    func getSupportedCurrencies() async {
        do {
            let currencies = try await useCase.getAvailableCurrencies()
            self.supportedCurrencies = currencies
            print("Supported -> \(self.supportedCurrencies.count)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getLatestRates() async {
        do {
            let rates = try await useCase.fetchLatestRates(baseCurrency: "USD")
            currencyRates = rates
            print("Currency rates -> \(currencyRates.count)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func swapCurrencies() {
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
    }

    func clearData() {
        fromCurrency = nil
        toCurrency = nil
        amount = ""
        convertedAmount = ""
    }
    
    func getConversionRate() {
        guard let from = fromCurrency?.code,
              let to = toCurrency?.code,
              !amount.isEmpty,
              let amountValue = Double(amount) else {
            convertedAmount = ""
            return
        }
        
        let baseValue = amountValue / (currencyRates[from] ?? 1.0)
        let converted = baseValue * (currencyRates[to] ?? 1.0)
        convertedAmount = String(format: "%.2f", converted)
    }
}
