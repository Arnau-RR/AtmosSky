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
    
    var body: some View {
        
        NavigationStack {
            
            listAndFavourites
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
            
            List {
                
                ForEach(viewModel.favoriteCitiesWeather) { city in
                    
                    FavouriteListCell(
                        cityName: city.cityName,
                        cityGlobal: city.weatherDescription,
                        weatherCode: city.weatherCode,
                        temperatureDegree: "\(city.temperature)°",
                        maxTemperature: "\(city.maxTemperature)°",
                        minTemperature: "\(city.minTemperature)°"
                    ) {
                        
                        onCitySelected(
                            city.latitude,
                            city.longitude
                        )
                        
                        dismiss()
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: 6,
                            leading: 16,
                            bottom: 6,
                            trailing: 16
                        )
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            //            .navigationTitle("Favoritos")
            //            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            
            viewModel.configure(modelContext: modelContext)
            
            Task {
                await viewModel.loadFavorites()
                await viewModel.loadWeatherForFavorites()
            }
        }
    }
}

extension FavouriteListView {
    
    var listAndFavourites: some View {
        HStack {
            Spacer()
            GlassButtonComponent(padding: 1) {
                dismiss()
            } content: {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
            }
        }
    }
}
