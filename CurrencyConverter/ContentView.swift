//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 13/08/2025.
//

import Alamofire
import SwiftUI

struct ContentView: View {
    @State private var fromCurrency: Currency?
    @State private var toCurrency: Currency?
    @State private var amount: String = ""
    @State private var convertedAmount: String = ""

    @State private var showFromSheet = false
    @State private var showToSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.blue)

                    Text("Convert currencies in real-time")
                        .foregroundStyle(.secondary)

                    Spacer().frame(height: 24)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.up.circle")
                                .foregroundStyle(.secondary)
                            Text("From")
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            Button(action: {
                                showFromSheet.toggle()
                            }, label: {
                                HStack {
                                    if let countryCode = fromCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(fromCurrency?.code ?? "Select")

                                        if let symbol = fromCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            })

                            Divider()

                            TextField("Enter Amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )

                        Button(action: swapCurrencies) {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()

                        HStack {
                            Image(systemName: "arrow.down.circle")
                                .foregroundStyle(.secondary)
                            Text("To")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Button(action: {
                                showToSheet.toggle()
                            }, label: {
                                HStack {
                                    if let countryCode = toCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(toCurrency?.code ?? "Select")

                                        if let symbol = toCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            })

                            Divider()

                            TextField("Converted Amount", text: $convertedAmount)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                                .disabled(true)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
                .padding()
                .navigationTitle("Currency Converter")
                .toolbar {
                    ToolbarItem {
                        Button("Clear") {
                            clearData()
                        }
                    }
                }
                .sheet(isPresented: $showFromSheet) {
                    CurrencyPickerView(selectedCurrency: $fromCurrency)
                }
                .sheet(isPresented: $showToSheet) {
                    CurrencyPickerView(selectedCurrency: $toCurrency)
                }
            }
            .task {
                getData()
            }
        }
    }
    private func getData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request("https://v6.exchangerate-api.com/v6/57294560b881599db71a71e1/latest/USD")
            .responseDecodable(of: CurrencyResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let currencies):
                    print("Successfully fetched \(currencies.conversionRates.count) currencies")
                    print(currencies.conversionRates)
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle the error
                }
            }
    }
    private func swapCurrencies() {
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
    }

    private func clearData() {
        fromCurrency = nil
        toCurrency = nil
        amount = ""
        convertedAmount = ""
    }
}

struct CurrencyResponse: Codable {
    let conversionRates: [String: Double]
}

#Preview {
    ContentView()
}
