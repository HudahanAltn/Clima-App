//
//  WeatherManager.swift
//  Clima App
//
//  Created by Hüdahan Altun on 16.10.2022.
//

import Foundation
import UIKit
import CoreLocation



class weatherManager{
    
    var delegate:weatherManagerProtocol?
    
    var weatherURL = apı.weatherURL //apı url

        
    func fecthWeather(cityName:String){//şehre göre hava durumunu getirecek olan metod
        
        let urlString = "\(weatherURL)&q=\(cityName)" //api adresini düzenliyoruz ve arayacağımız sehir adını giriyoruz.
        
        performRequest(urlString: urlString)
    }
    
    func fecthWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){//şehre göre hava durumunu getirecek olan metodu aşırı yükleyerek koordinat alabilir hale getirdik.
        
        let coordinates = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)" //api adresini düzenliyoruz ve corelocaiton'dan gelen koordinat veirleri ni url' şeklinde alıyoruz
        
        performRequest(urlString: coordinates) //fonksiyona veriyoruz
    }
    
    
    func performRequest(urlString:String){ // hava durumu verisi çekeceğimiz için bu bir get fonksiyonudur.
        
        
        if let url = URL(string: urlString){//url i güvenli şekilde aldık
            
            URLSession.shared.dataTask(with: url) { //URLSession nesnesi
                
                (data,response,error) in //url ile gelen yapılar bu 3 parametrede depolanır
                
                if error != nil || data == nil{
                    
                    print("API isteği başarısız!")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                //json parse işlemi do-catch bloklarında yapılır
               
                
                
                if let safeData = data{ //data'yı if let ile güvenli şlekilde aldık
                    
                    if  let weather = self.parseJSON(weatherData: safeData){
                        //json parse iiçn fonksiyona yolladık ve return ü  güvenli şekilde geri aldık
                        
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                        
                        
                    

                }

                
            }.resume()
        }
    }
    
    func parseJSON(weatherData:Data)->weatherModel?{ //parse başarılı olur veya olmaz diye return'lü fonk tanımladık aşağıdaki bloklardan birinde hata gelirse direkt catch çalışacak ve nil return edilecek
        
        do{

            // json verilerini parse edip WeatherData sınıfına göre uyarladık
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            
            // ihtiyacımız olan verileri buradan aldık
            let name  = decodedData.name
            let temperature = decodedData.main.temp
            let conditionID = decodedData.weather[0].id
            
            // verilerle yeni bir nesne oluşturduk.bu nesne ile arayüzümüzü şekillendireceğiz
            let weatherModel = weatherModel(coditionID: conditionID, cityname: name, temperature: temperature)
            print("şehir:\(weatherModel.cityname)")
            print("hava şuan:\(weatherModel.conditionName)")
            print("hava sıcaklık:\(weatherModel.temperature)")
         
            print("json parse basarılı")
            
            return weatherModel
         
        }catch{

            print("json parse başarısız!")
            
            self.delegate?.didFailWithError(error: error)
            return nil // hata durumunda nil döndür
        }
    }
    
    
   
}
