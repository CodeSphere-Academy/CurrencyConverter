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
    @Published var convertedAmount: String = "First version"
    @Published var fromCurrency: Currency?
    var currencyRates = [String: Double]()
    func getData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let url = AppConfig.baseUrl + "/" + AppConfig.apiVersion + "/" + AppConfig.apiKey + "/"
        AF.request("\(url)latest/USD")
            .responseDecodable(of: CurrencyResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let currencies):
                    print("Successfully fetched \(currencies.conversionRates.count) currencies")
                    self.currencyRates = currencies.conversionRates
                    self.convertedAmount = "\(self.currencyRates.count)"
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle the error
                }
            }
    }
}
