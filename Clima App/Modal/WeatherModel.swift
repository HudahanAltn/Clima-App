//
//  WeatherModel.swift
//  Clima App
//
//  Created by Hüdahan Altun on 20.10.2022.
//

import Foundation


//arayüze veri aktarımı için kullanılacak sınıf

class weatherModel{
    
    var conditionID:Int // bu ID ye göre ekranda havadurumuna ait resim çıkacak
    var cityname:String// sehir ismi
    var temperature:Double //sıcaklık
    var temperatureString:String{//sıcaklıkğı stringe çevirdik 
        
        return String(format: "%.1f", temperature)
    }
    var conditionName:String{//computed property ile ıd2ye göre resim çekmek için kullanacağız.
        
        switch conditionID{//buId ile ilgili resmin adını aldık
         
            //case ile aralık belirtioyurz
        case 200...232:
            return "cloud.bolt"
        
        case 300...321:
            return "cloud.drizzle"
            
        case 500...531:
            return "cloud.rain"
           
        case 600...622:
            return "cloud.snow"
            
        case 700...781:
            return "cloud.fog"
            
        case 800:
            return "sun.max"
        
        case 801...804:
            return "cloud.bolt"
    
        default:
            
            return "cloud"
        }
        
        
    }
    
    init(coditionID:Int,cityname:String,temperature:Double){
        
        self.conditionID = coditionID
        self.cityname = cityname
        self.temperature = temperature
    }
    
   
}
