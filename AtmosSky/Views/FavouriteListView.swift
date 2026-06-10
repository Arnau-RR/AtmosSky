//
//  FavouriteListView.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import SwiftUI
import SwiftData

struct FavouriteListView: View {

    let onCitySelected: (Double, Double) -> Void

    @StateObject private var viewModel = FavouriteListModel()

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            header
            searchBar
            Divider()
                .opacity(0.15)
            listContent
        }
        //.background(.ultraThinMaterial.opacity(0.6))
        //.clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal, 16)
        .padding(.vertical, 30)
        .onAppear {
            viewModel.configure(modelContext: modelContext)
            Task {
                await viewModel.loadFavorites()
                await viewModel.loadWeatherForFavorites()
            }
        }
    }
}

// MARK: - Views

extension FavouriteListView {

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favoritos")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Selecciona una ciudad")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            GlassButtonComponent(padding: 1) {
                dismiss()
            } content: {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
            }
        }
        .padding()
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            if viewModel.isSearching {
                ProgressView()
                    .scaleEffect(0.8)
                    .tint(.white.opacity(0.6))
            } else {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.6))
            }

            TextField("Buscar ciudad...", text: $searchText)
                .foregroundStyle(.white)
                .tint(.white)
                .submitLabel(.search)
                .onSubmit {
                    Task { await viewModel.searchCities(query: searchText) }
                }
                .onChange(of: searchText) { _, value in

                    let query = value.trimmingCharacters(in: .whitespaces)

                    if query.count >= 2 {

                        Task {
                            await viewModel.searchCities(query: query)
                        }

                    } else {

                        viewModel.clearSearch()
                    }
                }

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.white.opacity(0.2), lineWidth: 0.5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

//    private var listContent: some View {
//        List {
//
//            // MARK: Resultados de búsqueda
//            if !viewModel.searchResults.isEmpty {
//                Section {
//                    ForEach(viewModel.searchResults) { result in
//                        searchResultRow(result)
//                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
//                            .listRowBackground(Color.clear)
//                            .listRowSeparator(.hidden)
//                    }
//                } header: {
//                    Text("Resultados".uppercased())
//                        .font(.caption)
//                        .foregroundStyle(.white.opacity(0.5))
//                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
//                }
//            }
//
//            // MARK: Favoritos guardados
//            Section {
//                ForEach(viewModel.favoriteCitiesWeather) { city in
//                    FavouriteListCell(
//                        cityName: city.cityName,
//                        cityGlobal: city.weatherDescription,
//                        weatherCode: city.weatherCode,
//                        temperatureDegree: "\(city.temperature)°",
//                        maxTemperature: "\(city.maxTemperature)°",
//                        minTemperature: "\(city.minTemperature)°"
//                    ) {
//                        onCitySelected(city.latitude, city.longitude)
//                        dismiss()
//                    }
//                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                    .listRowBackground(Color.clear)
//                    .listRowSeparator(.hidden)
//                }
//            } header: {
//                if !viewModel.searchResults.isEmpty {
//                    Text("Mis favoritos".uppercased())
//                        .font(.caption)
//                        .foregroundStyle(.white.opacity(0.5))
//                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
//                }
//            }
//        }
//        .listStyle(.plain)
//        .scrollContentBackground(.hidden)
//    }
    
    private var listContent: some View {

        ScrollView(showsIndicators: false) {

            LazyVStack(spacing: 10) {

                // Resultados búsqueda
                if !viewModel.searchResults.isEmpty {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("RESULTADOS")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(viewModel.searchResults) { result in
                            searchResultRow(result)
                        }
                    }
                }

                // Favoritos
                if !viewModel.favoriteCitiesWeather.isEmpty {

                    VStack(alignment: .leading, spacing: 8) {

                        if !viewModel.searchResults.isEmpty {
                            Text("MIS FAVORITOS")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ForEach(viewModel.favoriteCitiesWeather) { city in

                            FavouriteListCell(
                                cityName: city.cityName,
                                cityGlobal: city.weatherDescription,
                                weatherCode: city.weatherCode,
                                temperatureDegree: "\(city.temperature)°",
                                maxTemperature: "\(city.maxTemperature)°",
                                minTemperature: "\(city.minTemperature)°"
                            ) {
                                onCitySelected(city.latitude, city.longitude)
                                dismiss()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }

    @ViewBuilder
    private func searchResultRow(_ result: CitySearchResult) -> some View {

        Button {

            onCitySelected(
                result.latitude,
                result.longitude
            )

            dismiss()

        } label: {

            HStack {

                VStack(alignment: .leading, spacing: 2) {

                    Text(result.name)
                        .font(.system(size: 15, weight: .medium))

                    Text(result.country)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                Button {

                    Task {
                        await viewModel.addToFavorites(result)
                    }

                } label: {

                    Image(systemName: "heart.badge.plus")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
//    private func searchResultRow(_ result: CitySearchResult) -> some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 2) {
//                Text(result.name)
//                    .font(.system(size: 15, weight: .medium))
//                    .foregroundStyle(.white)
//
//                Text(result.country)
//                    .font(.caption)
//                    .foregroundStyle(.white.opacity(0.5))
//            }
//
//            Spacer()
//
//            Button {
//                Task {
//                    await viewModel.addToFavorites(result)
//                    searchText = ""
//                }
//            } label: {
//                Image(systemName: "plus.circle.fill")
//                    .font(.title3)
//                    .foregroundStyle(.white.opacity(0.7))
//            }
//            .buttonStyle(.plain)
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 10)
//        .background(.white.opacity(0.06))
//        .clipShape(RoundedRectangle(cornerRadius: 14))
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(.white.opacity(0.12), lineWidth: 0.5)
//        )
//    }
}
