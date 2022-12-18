//
//  ViewController.swift
//  Clima App
//
//  Created by Hüdahan Altun on 12.10.2022.
//

import UIKit

import CoreLocation // konum bilgilerini almak için import edilir.
class ViewController: UIViewController{

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManagerr = weatherManager() //hava durumu verilerini almak için nesne oluştruduk
    
    let locationManagerr:CLLocationManager = CLLocationManager() //konum bilgilerini alacağımız sınıf
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self //protocol connect this VC
        weatherManagerr.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.keyboardType = .default
        searchTextField.returnKeyType = .go
        
        locationManagerr.delegate = self
//        locationManagerr.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerr.requestWhenInUseAuthorization() // konum kullanma izni
        locationManagerr.requestLocation() // 1 kerelik konum alma talebi (sürekli takio gerektirmeyen uyg iiçin) (sürekli konum verisi almak için startUpdatingLocation() kullanılır)
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        print("(searchbuttonpressediçi)aranan sehir:\(searchTextField.text!)")
        
        searchTextField.endEditing(true)//textField'da düzenlemenin durduğunu belirtiriz.
        
       
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        
        locationManagerr.requestLocation()
    }
}


//MARK: - TextfieldDelegate

extension ViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // kullanıcı enter(return,go) tuşuna basınca ne yapması gerketiğini belirten protocol metodudur. return tuşuna basınca yapılması istenenler gövdede belirtilir
        
        print("aranan sehir(shouldReturniçi):\(searchTextField.text!)")
        
        searchTextField.endEditing(true)// //textField'da düzenlemenin durduğunu belirtiriz.
        
        return true // go tuşuna basıldı
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {//textifeld'ın düzenlenmesi bittiğini belirten protocol metodudur. düzenleme bitince yapılması istenenler gövdede belirtilir
        
        
        if let cityName = searchTextField.text{ //sehir adının yazılacağı textfield'den veriyi if let ile aldık.
            
            
            weatherManagerr.fecthWeather(cityName: cityName)// metoda textfield'dan gelen veriiy geçiyoruz.
            
            
        }
        
       
        searchTextField.text = "" //içeriği sıfırla
        
       
    }
    

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { //düzenlemenin bitip bitmeyeceğinin kotrnolü yapılır.ona göre return edilir.
        
        if searchTextField.text != ""{ // textfield dolu ise
            
            return true//Düzenleme bitti
        }else{
            
            textField.placeholder = "type something"
            return false // düzenleme bitmedi
        }
    }
}

//MARK: - WeatherManager

extension ViewController:weatherManagerProtocol{
    
    func didUpdateWeather(_ weatherManager:weatherManager,weather: weatherModel) {
        
        DispatchQueue.main.async {
            
            self.cityLabel.text = weather.cityname
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
    }
}


//MARK: - CoreLocation

extension ViewController:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //coreLocation birkaç defa konum almaya çalışarak en doğru konum bilgisini elde etmeye çalışır.böylece bütün konumlaırn bulunduğu "locations" dizisi oluşturulur.dizinin en son elemanı en doğru konumu verir
        if let locationInf = locations.last {// konumu aldık
            
            locationManagerr.stopUpdatingLocation()
            let latitude = locationInf.coordinate.latitude
            let longitude = locationInf.coordinate.longitude
        
            weatherManagerr.fecthWeather(latitude: latitude, longitude: longitude)
            
            print(latitude)
            print(longitude)
        }
        
        
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("konum hatası")
        print(error)
    }
}
