//
//  CurrencyResponse.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 24/8/25.
//

import Foundation

struct CurrencyResponse: Codable {
    let conversionRates: [String: Double]
}

struct CurrencyCodeResponse: Decodable {
    let supportedCodes: [[String]]
}
