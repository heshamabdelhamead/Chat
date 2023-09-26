//
//  mapViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/09/2023.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftBarButton()
        configureMapView()
        self.title = "map view"
        
    }
    //MARK: variables
    var mapView : MKMapView!
    var location : CLLocation!
    
    private func configureMapView(){
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mapView.showsUserLocation = true
        
        if location != nil{
            mapView.setCenter(location.coordinate, animated: true)
            mapView.addAnnotation(mapAnnotation(coordinate: location.coordinate, title: "user Location"))
        }
        view.addSubview(mapView)
        
        
    }
    
    
    
    private func configureLeftBarButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }



}
