//
//  ViewController.swift
//  weatherProject
//
//  Created by Olzhas Zhakan on 15.09.2023.
//

import UIKit
import Alamofire
import SnapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {
    var lastApiRequestTime: Date?
    let locationManager = CLLocationManager()
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 56)
        label.textColor = .white
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 15
            layout.minimumInteritemSpacing = 15
            layout.itemSize = CGSize(width: 150, height: 200)
            return layout
        }()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    var dailyForecasts: [DailyWeather] = []
    
    let apiKey = "215e8357c64536d2060333d77a8097b9"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(collection)
        makeConstraints()
        setupOther()

    }

    func setupOther() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.reuseIdentifier)
        collection.layer.cornerRadius = 10
        collection.clipsToBounds = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func makeConstraints() {
        tempLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        collection.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentTime = Date()
            if let lastRequestTime = lastApiRequestTime, currentTime.timeIntervalSince(lastRequestTime) < 300 {
                return
            }
            //  let latitude = location.coordinate.latitude
            //  let longitude = location.coordinate.longitude
            let latitude = 43.2566700
            let longitude = 76.9286100
            
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)" // 2.5
            AF.request(url).responseJSON { response in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        self.updateUI(with: weatherData)
                    } catch {
                        print("Ошибка декодирования данных: \(error)")
                    }
                }
            }
        }
    }
    func imageName(for weatherDescription: String) -> String {
        switch weatherDescription {
        case "clear sky":
            return "sunny"
        case "few clouds", "scattered clouds", "broken clouds":
            return "cloud"
        case "light rain", "moderate rain", "heavy rain":
            return "rai"
        default:
            return "default"
        }
    }
    
    func updateUI(with weather: WeatherData) {
        let temperatureInKelvin = weather.current.temp
        let temperatureInCelsius = temperatureInKelvin - 273.15
        
        let temperatureFormatter = NumberFormatter()
        temperatureFormatter.numberStyle = .decimal
        temperatureFormatter.maximumFractionDigits = 2
        
        if let formattedTemperature = temperatureFormatter.string(from: NSNumber(value: temperatureInCelsius)) {
            let formattedTemperatureText = "\(formattedTemperature)°C"
            tempLabel.text = formattedTemperatureText
        }
        
        let currentWeatherDescription = weather.current.weather[0].description
        let backgroundImageName = imageName(for: currentWeatherDescription.lowercased())

        if let backgroundImage = UIImage(named: backgroundImageName) {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        } else {
            view.backgroundColor = .white
        }
        descriptionLabel.text = currentWeatherDescription
        
        dailyForecasts = weather.daily
//        for forecast in dailyForecasts {
//            print("Day: \(forecast.dt), Temperature: \(forecast.temp.day)°C")
//        }
        
        collection.reloadData()
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecasts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.reuseIdentifier, for: indexPath) as! DailyCell
        
        let forecast = dailyForecasts[indexPath.item]
        cell.configure(with: forecast)
        
        return cell
    }

}
