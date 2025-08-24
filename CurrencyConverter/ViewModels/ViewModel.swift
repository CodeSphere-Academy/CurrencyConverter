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
    var currencyRates = [String: Double]()
    init(useCase: CurrencyUseCaseDelegate = CurrencyUseCase()) {
        self.useCase = useCase
        getData()
    }
    
    func getData() {
        let dummy = useCase.getAvailableCurrencies()
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
}
