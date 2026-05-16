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
        
        let url = URL(string:
            "https://api.open-meteo.com/v1/forecast" +
            "?latitude=\(latitude)" +
            "&longitude=\(longitude)" +
            "&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code" +
            "&hourly=temperature_2m,precipitation_probability,weather_code" +
            "&daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset" +
            "&timezone=auto" +
            "&format=flatbuffers"
        )!
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        
        let response = responses[0]
        
        /// Attributes for timezone and location
        let latitude = response.latitude
        let longitude = response.longitude
        let elevation = response.elevation
        let current = response.current!
        let hourly = response.hourly!
        let daily = response.daily!
        
        guard let dailySunrise = daily.variables(at: 3)?.valuesInt64,
              let dailySunset = daily.variables(at: 4)?.valuesInt64 else {
            throw NSError(
                domain: "WeatherService",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "No se pudieron obtener sunrise/sunset"
                ]
            )
        }
        
        // Current values
        let temperature = Double(current.variables(at: 0)!.value)
        let apparentTemperature = Double(current.variables(at: 1)!.value)
        let humidity = Double(current.variables(at: 2)!.value)
        let windSpeed = Double(current.variables(at: 3)!.value)
        let weatherCode = Int(current.variables(at: 4)!.value)
        
        print("Weather code actual: \(weatherCode)")
        
        let currentWeatherDescription = weatherDescription(for: weatherCode)
        
        // Today's max/min
        let maxTemperature = Double(daily.variables(at: 0)!.values[0])
        let minTemperature = Double(daily.variables(at: 1)!.values[0])
        
        let utcOffsetSeconds = response.utcOffsetSeconds
        
        let locationTimeZone = TimeZone(secondsFromGMT: Int(utcOffsetSeconds)) ?? .gmt

        // Hora actual en la ubicación seleccionada.
        let localDate = Date()

        // Cálculo correcto de si AHORA es de noche en la ubicación consultada.
        let todaySunrise = Date(timeIntervalSince1970: TimeInterval(dailySunrise[0]))
        let todaySunset = Date(timeIntervalSince1970: TimeInterval(dailySunset[0]))
        let isNight = !(localDate >= todaySunrise && localDate < todaySunset)
        
        let localTimeFormatter = DateFormatter()
        localTimeFormatter.timeZone = locationTimeZone
        localTimeFormatter.dateFormat = "EEEE d MMMM yyyy, HH:mm"

        print("Hora local en la ubicación consultada: \(localTimeFormatter.string(from: localDate))")
        print("Zona horaria: \(locationTimeZone.identifier)")
        
        print("\nCoordinates: \(latitude)°N \(longitude)°E")
        print("Elevation: \(elevation)m asl")
        print("Timezone difference to GMT+0: \(utcOffsetSeconds)s")
        
        let dailyTimes = daily.getDateTime(offset: utcOffsetSeconds)
        let dailyMaxTemps = daily.variables(at: 0)!.values
        let dailyMinTemps = daily.variables(at: 1)!.values
        let dailyWeatherCodes = daily.variables(at: 2)!.values
        
        let dailyForecast: [DailyForecast] = dailyTimes.indices.map { index in
            
            let sunriseDate = dailySunrise.indices.contains(index)
            ? Date(timeIntervalSince1970: TimeInterval(dailySunrise[index]))
            : nil
            
            let sunsetDate = dailySunset.indices.contains(index)
            ? Date(timeIntervalSince1970: TimeInterval(dailySunset[index]))
            : nil
            
            // Calculate daylight hours
            let daylightHours: Double? =
            if let sunrise = sunriseDate, let sunset = sunsetDate {
                sunset.timeIntervalSince(sunrise) / 3600.0
            } else {
                nil
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(secondsFromGMT: Int(utcOffsetSeconds))
            
            if let sunriseDate,
               let sunsetDate,
               let daylightHours {
                print("Sunrise: \(formatter.string(from: sunriseDate))")
                print("Sunset: \(formatter.string(from: sunsetDate))")
                print("Horas de luz: \(String(format: "%.1f", daylightHours)) h")
            }

            print("¿Es de noche?: \(isNight)")
            
            return DailyForecast(
                date: dailyTimes[index],
                maxTemperature: Double(dailyMaxTemps[index]),
                minTemperature: Double(dailyMinTemps[index]),
                weatherCode: Int(dailyWeatherCodes[index]),
                sunrise: sunriseDate,
                sunset: sunsetDate,
                daylightHours: daylightHours
                
            )
        }
        
        let hourlyTimes = hourly.getDateTime(offset: utcOffsetSeconds)
        let hourlyTemperatures = hourly.variables(at: 0)!.values
        let hourlyPrecipitation = hourly.variables(at: 1)!.values
        let hourlyWeatherCodes = hourly.variables(at: 2)!.values
        
        let hourlyForecast = hourlyTimes.indices.map { index in
            HourlyForecast(
                date: hourlyTimes[index],
                temperature: Double(hourlyTemperatures[index]),
                precipitationProbability: Double(hourlyPrecipitation[index]),
                weatherCode: Int(hourlyWeatherCodes[index])
            )
        }
        
        let data = WeatherData(
            cityName: "",
            temperature: temperature,
            maxTemperature: maxTemperature,
            minTemperature: minTemperature,
            apparentTemperature: apparentTemperature,
            humidity: humidity,
            windSpeed: windSpeed,
            currentWeatherCode: weatherCode,
            currentWeatherDescription: currentWeatherDescription,
            timeZone: locationTimeZone,
            localDate: localDate,
            isNight: isNight,
            hourly: nil,
            dailyForecast: dailyForecast,
            hourlyForecast: hourlyForecast
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
        
        /// Timezone '.gmt' is deliberately used.
        /// By adding 'utcOffsetSeconds' before, local-time is inferred
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return data
    }
    
    private func weatherDescription(for code: Int) -> String {
        switch code {
        case 0:
            return "Cielo despejado"
        case 1:
            return "Mayormente despejado"
        case 2:
            return "Parcialmente nublado"
        case 3:
            return "Nublado"
        case 45, 48:
            return "Niebla"
        case 51:
            return "Llovizna débil"
        case 53:
            return "Llovizna moderada"
        case 55:
            return "Llovizna intensa"
        case 61:
            return "Lluvia débil"
        case 63:
            return "Lluvia moderada"
        case 65:
            return "Lluvia fuerte"
        case 66, 67:
            return "Lluvia helada"
        case 71:
            return "Nieve débil"
        case 73:
            return "Nieve moderada"
        case 75:
            return "Nieve intensa"
        case 77:
            return "Granos de nieve"
        case 80:
            return "Chubascos débiles"
        case 81:
            return "Chubascos moderados"
        case 82:
            return "Chubascos violentos"
        case 85:
            return "Nevadas débiles"
        case 86:
            return "Nevadas intensas"
        case 95:
            return "Tormenta"
        case 96:
            return "Tormenta con granizo débil"
        case 99:
            return "Tormenta con granizo fuerte"
        default:
            return "Condición desconocida"
        }
    }
}
