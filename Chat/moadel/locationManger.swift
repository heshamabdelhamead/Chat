//
//  locationManger.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/09/2023.
//

import Foundation
import CoreLocation

class LocationManger :  NSObject , CLLocationManagerDelegate{
    
    static let shared = LocationManger()
    
    var locationManger : CLLocationManager?
    var curentLocation : CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        self.requestLocationAccess()
    }
    func requestLocationAccess(){
        if locationManger == nil {
            locationManger = CLLocationManager()
            locationManger!.delegate = self
            locationManger!.desiredAccuracy = kCLLocationAccuracyBest
            locationManger!.requestWhenInUseAuthorization()
            
        }else {
            print("we already have a manger")
        }
        
    }
    func startUpdating(){
        locationManger!.startUpdatingLocation()
        
    }
    func stopUpdating (){
        if locationManger != nil {
            locationManger!.stopUpdatingLocation()
        }
    }
        //MARK:- Delegate Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        curentLocation = locations.last!.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("failed to get description ", error.localizedDescription)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined{
            self.locationManger!.requestWhenInUseAuthorization()
        }
    }
    
}
