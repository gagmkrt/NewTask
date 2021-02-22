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
    func pressed(name: String, email: String, Image: NSData)
}

class UserDetailsController: BaseViewController {
    
    var getList = "/api?results=50"
    var name = ""
    var value = ""
                
    var lat: Double?
    var lng: Double?
    var country = ""
    
    var manager = CLLocationManager()
    let roundButton = UIButton()
    
    var realm = try! Realm()
    
    let us = User()
    
    weak var delegate: UserDetailsControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton()
        fetchData()
        setLocation()
    }
    
    func fetchData() {
        NetWorkService.request(url: getList + name + value, method: .get, param: nil, encoding: JSONEncoding.default) { (response: ResultModel) in
            self.userName.text = response.name?.fullName
            self.userPhone.text = response.phone
            self.userEmail.text = response.email
            self.country = response.country ?? ""
            if let cover = response.photoUrl {
                self.userImage.kf.setImage(with: cover)
            }
        }
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
        let span = MKCoordinateSpan(latitudeDelta: lat ?? 0, longitudeDelta: lng ?? 0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
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
        delegate?.pressed(name: us.name, email: us.email, Image: us.photoData!)
        roundButton.isSelected ? saveInfo() : remove()
        roundButton.setTitle(roundButton.isSelected ? "Save" : "Delete", for: .normal)
        roundButton.backgroundColor = roundButton.isSelected ? .link : .red
        roundButton.isSelected.toggle()
    }
    
    func saveInfo() {
        us.name = userName.text ?? ""
        us.email = userEmail.text ?? ""
        us.photoData = NSData(data: userImage.image!.pngData()!)

        realm.beginWrite()
        realm.add(us)
        try! realm.commitWrite()
    }
    
    func remove() {
        realm.beginWrite()
        realm.delete(realm.objects(User.self))
        try! realm.commitWrite()
    }
}


class User: Object {
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var photoData: NSData? = nil
}
