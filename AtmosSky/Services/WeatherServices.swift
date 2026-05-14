//
//  WeatherServices.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import Foundation
import OpenMeteoSdk

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData
}

@MainActor
final class WeatherService: WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        // Aquí usarás el SDK de Open-Meteo
        
        let url = URL(string:
                        "https://api.open-meteo.com/v1/forecast" +
                      "?latitude=\(latitude)" +
                      "&longitude=\(longitude)" +
                      "&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m" +
                      "&daily=temperature_2m_max,temperature_2m_min" +
                      "&timezone=auto" +
                      "&format=flatbuffers"
        )!
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        
        let response = responses[0]
        
        print(response)
        
        /// Attributes for timezone and location
        let latitude = response.latitude
        let longitude = response.longitude
        let elevation = response.elevation
        let current = response.current!
        let daily = response.daily!
        
        // Current values
        let temperature = Double(current.variables(at: 0)!.value)
        let apparentTemperature = Double(current.variables(at: 1)!.value)
        let humidity = Double(current.variables(at: 2)!.value)
        let windSpeed = Double(current.variables(at: 3)!.value)
        
        // Daily values (today = first element)
        let maxTemperature = Double(daily.variables(at: 0)!.values[0])
        let minTemperature = Double(daily.variables(at: 1)!.values[0])
        
        let utcOffsetSeconds = response.utcOffsetSeconds
        
        print("\nCoordinates: \(latitude)°N \(longitude)°E")
        print("Elevation: \(elevation)m asl")
        print("Timezone difference to GMT+0: \(utcOffsetSeconds)s")
        
        let data = WeatherData(
            cityName: "",
            temperature: temperature,
            maxTemperature: maxTemperature,
            minTemperature: minTemperature,
            apparentTemperature: apparentTemperature,
            humidity: humidity,
            windSpeed: windSpeed,
            hourly: nil
            //            hourly: .init(
            //                time: hourly.getDateTime(offset: utcOffsetSeconds),
            //                showers: hourly.variables(at: 0)!.values,
            //                snowfall: hourly.variables(at: 1)!.values,
            //                snowDepth: hourly.variables(at: 2)!.values,
            //                cloudCover: hourly.variables(at: 3)!.values,
            //                cloudCoverLow: hourly.variables(at: 4)!.values,
            //                cloudCoverMid: hourly.variables(at: 5)!.values,
            //                cloudCoverHigh: hourly.variables(at: 6)!.values,
            //                visibility: hourly.variables(at: 7)!.values,
            //                evapotranspiration: hourly.variables(at: 8)!.values,
            //                et0FaoEvapotranspiration: hourly.variables(at: 9)!.values,
            //                vapourPressureDeficit: hourly.variables(at: 10)!.values,
            //                windSpeed10m: hourly.variables(at: 11)!.values,
            //                windSpeed80m: hourly.variables(at: 12)!.values,
            //                windSpeed120m: hourly.variables(at: 13)!.values,
            //                windSpeed180m: hourly.variables(at: 14)!.values,
            //                windDirection10m: hourly.variables(at: 15)!.values,
            //                windDirection80m: hourly.variables(at: 16)!.values,
            //                temperature80m: hourly.variables(at: 17)!.values,
            //                temperature120m: hourly.variables(at: 18)!.values,
            //                temperature180m: hourly.variables(at: 19)!.values,
            //                windDirection120m: hourly.variables(at: 20)!.values,
            //                windDirection180m: hourly.variables(at: 21)!.values,
            //                windGusts10m: hourly.variables(at: 22)!.values,
            //                soilTemperature0cm: hourly.variables(at: 23)!.values,
            //                soilTemperature6cm: hourly.variables(at: 24)!.values,
            //                soilTemperature18cm: hourly.variables(at: 25)!.values,
            //                soilTemperature54cm: hourly.variables(at: 26)!.values,
            //                soilMoisture0To1cm: hourly.variables(at: 27)!.values,
            //                soilMoisture1To3cm: hourly.variables(at: 28)!.values,
            //                soilMoisture3To9cm: hourly.variables(at: 29)!.values,
            //                soilMoisture9To27cm: hourly.variables(at: 30)!.values,
            //                soilMoisture27To81cm: hourly.variables(at: 31)!.values,
            //                temperature2m: hourly.variables(at: 32)!.values,
        //),
        )
        
        print(data)
        
        /// Timezone '.gmt' is deliberately used.
        /// By adding 'utcOffsetSeconds' before, local-time is inferred
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return data
    }
}
