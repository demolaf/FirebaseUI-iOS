//
//  CountrySelector.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct CountrySelector: View {
    let selectedCountry: CountryData
    let onCountrySelected: (CountryData) -> Void
    var enabled: Bool = true
    var allowedCountries: Set<String>? = nil

    // Common countries list
    private let allCountries: [CountryData] = [
        CountryData(name: "United States", dialCode: "+1", code: "US"),
        CountryData(name: "United Kingdom", dialCode: "+44", code: "GB"),
        CountryData(name: "Canada", dialCode: "+1", code: "CA"),
        CountryData(name: "Australia", dialCode: "+61", code: "AU"),
        CountryData(name: "Germany", dialCode: "+49", code: "DE"),
        CountryData(name: "France", dialCode: "+33", code: "FR"),
        CountryData(name: "India", dialCode: "+91", code: "IN"),
        CountryData(name: "Nigeria", dialCode: "+234", code: "NG"),
        CountryData(name: "South Africa", dialCode: "+27", code: "ZA"),
        CountryData(name: "Japan", dialCode: "+81", code: "JP"),
        CountryData(name: "China", dialCode: "+86", code: "CN"),
        CountryData(name: "Brazil", dialCode: "+55", code: "BR"),
        CountryData(name: "Mexico", dialCode: "+52", code: "MX"),
        CountryData(name: "Spain", dialCode: "+34", code: "ES"),
        CountryData(name: "Italy", dialCode: "+39", code: "IT"),
    ]

    private var filteredCountries: [CountryData] {
        if let allowedCountries = allowedCountries {
            return allCountries.filter { allowedCountries.contains($0.code) }
        }
        return allCountries
    }

    var body: some View {
        Menu {
            ForEach(filteredCountries, id: \.code) { country in
                Button {
                    onCountrySelected(country)
                } label: {
                    Text("\(country.flag) \(country.name) (\(country.dialCode))")
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedCountry.flag)
                    .font(.title3)
                Text(selectedCountry.dialCode)
                    .font(.body)
                    .foregroundStyle(.primary)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .disabled(!enabled)
    }
}

#Preview {
    CountrySelector(
        selectedCountry: .default,
        onCountrySelected: { _ in }
    )
}
