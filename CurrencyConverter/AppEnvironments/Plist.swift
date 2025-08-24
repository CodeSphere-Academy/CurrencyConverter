//
//  Plist.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 23/8/25.
//

import Foundation

func baseUrl() -> String {
    return AppConfig.baseUrl
}

func apiKey() -> String {
    return AppConfig.apiKey
}

enum Plist {
    case baseUrl
    case apiKey
    var value: String {
        switch self {
        case .baseUrl:
            return "Base URL"
            
        case .apiKey:
            return "API Key"
        }
    }
}
