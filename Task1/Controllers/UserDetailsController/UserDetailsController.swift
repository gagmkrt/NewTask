//
//  UserDetailsController.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 19.02.21.
//

import UIKit
import Alamofire
import MapKit
import RealmSwift

protocol UserDetailsControllerDelegate: class {
    func pressed(name: String, email: String, image: String)
}

class UserDetailsController: UIViewController {
 
// MARK: - API
    var getList = "/api?results=50"
// MARK: - Info proporties
    var usName = ""
    var usEmail = ""
    var usImage = ""
    var largeImage = ""
    var usPhone = ""
                
    var lat: Double?
    var lng: Double?
    var country = ""
    
    var manager = CLLocationManager()
    let roundButton = UIButton()
    
// MARK: - Delegate

    weak var delegate: UserDetailsControllerDelegate?
// MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton()
        setLocation()
        userName.text = usName
        userEmail.text = usEmail
        let url = URL(string: largeImage)
        userImage.kf.setImage(with: url)
        userPhone.text = usPhone
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }
    
    
    func setLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

extension UserDetailsController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.startUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 0, longitudinalMeters: 0)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = country
        mapView.addAnnotation(pin)
        manager.stopUpdatingLocation()
    }
}

extension UserDetailsController {
    func saveButton() {
        roundButton.layer.cornerRadius = 20
        roundButton.backgroundColor = UIColor.link
        roundButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        roundButton.setTitle("Save", for: .normal)
        view.insertSubview(roundButton, aboveSubview: scrollView)
        
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        roundButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        roundButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        roundButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        roundButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func pressed() {
        delegate?.pressed(name: usName, email: usEmail, image: usImage)
    }
}

