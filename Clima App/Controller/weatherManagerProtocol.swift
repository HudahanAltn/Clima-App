//
//  weatherManagerProtocol.swift
//  Clima App
//
//  Created by Hüdahan Altun on 20.10.2022.
//

import Foundation


protocol weatherManagerProtocol{
    
    func didUpdateWeather(_ weatherManager:weatherManager,weather: weatherModel)
    func didFailWithError(error:Error)
    
}
