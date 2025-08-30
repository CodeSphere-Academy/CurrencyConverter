//
//  CurrencyCodeMapper.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 30/8/25.
//

import Foundation

struct CurrencyCodeMapper {
    func map(input: CurrencyCodeResponse) -> [Currency] {
        input.supportedCodes.map {
            Currency(code: $0[0], name: $0[1], symbol: $0[0], countryCode: $0[0])
        }
    }
}
