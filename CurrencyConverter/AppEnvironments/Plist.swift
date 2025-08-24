//
//  Plist.swift
//  CurrencyConverter
//
//  Created by Nyan Lin Tun on 23/8/25.
//

import Foundation

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
