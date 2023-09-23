//
//  CollectionViewClass.swift
//  weatherProject
//
//  Created by Olzhas Zhakan on 23.09.2023.
//

import UIKit
import SnapKit
class DailyCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DailyCell"
    let dailyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    let lightBlueColor = UIColor.systemBlue.withAlphaComponent(0.7)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
       setupCell()
       stackViewConst()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func dayOfWeek(from timeInterval: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    func configure(with forecast: DailyWeather) {
        if let dayOfWeek = dayOfWeek(from: forecast.dt) {
            dailyLabel.text = dayOfWeek
        } else {
            dailyLabel.text = "Unknown"
        }
        let temperatureInKelvin = forecast.temp.day
        let temperatureInCelsius = temperatureInKelvin - 273.15
        let formattedTemperature = String(format: "%.2f°C", temperatureInCelsius)
        weatherLabel.text = formattedTemperature
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    
}

private extension DailyCell {
    func setupCell() {
        contentView.backgroundColor = lightBlueColor
        stackView.addArrangedSubview(dailyLabel)
        stackView.addArrangedSubview(weatherLabel)
        contentView.addSubview(stackView)
    }
    func stackViewConst() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dailyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }
        weatherLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
        }

    }
}
