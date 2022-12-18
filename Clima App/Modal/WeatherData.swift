//
//  WeatherData.swift
//  Clima App
//
//  Created by Hüdahan Altun on 17.10.2022.
//

import Foundation


//Json parse için sınıf oluşturuyoruz çünkü json verileride nesne tabanlıdır. bu nesnelerin swift class'ını oluşturursak parse tmesi daha  kolaylaşır

struct WeatherData:Codable{ // ANA SINIF
    //!!!!!!!!!!!! json key ile buradaki veri üyelerinin isimleri birebir aynı olmalıdır!!!!!!!!!
    
    var name:String
    var main:Main
    var weather:[Weather]
}


struct Main:Codable{
    
    var temp:Double
}


struct Weather:Codable{
    
    var description:String
    var id:Int
}
