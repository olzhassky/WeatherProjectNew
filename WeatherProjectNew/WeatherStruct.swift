//
//  WeatherStruct.swift
//  weatherProject
//
//  Created by Olzhas Zhakan on 17.09.2023.
//

import Foundation

struct WeatherData: Decodable {
    let current: CurrentWeather
    let daily: [DailyWeather]
    let alerts: [Alert]?
}

struct CurrentWeather: Decodable {
    let temp: Double
    let weather: [Weather]
}

struct DailyWeather: Decodable {
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let temp: Temperature
    let feelsLike: Temperature?
    let pressure: Int
    let humidity: Int
    let dewPoint: Double?
    let windSpeed: Double
    let windDeg: Double
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double
    let moonrise: TimeInterval
    let moonset: TimeInterval
    let moonPhase: Double
    let summary: String?

    private enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather
        case clouds
        case pop
        case rain
        case uvi
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
        case summary
    }
}

struct Temperature: Decodable {
    let day: Double
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Alert: Decodable {
    let senderName: String
    let event: String
    let start: TimeInterval
    let end: TimeInterval
    let description: String
    let tags: [String]
}
