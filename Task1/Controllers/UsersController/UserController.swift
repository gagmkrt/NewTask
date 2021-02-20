//
//  UserController.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import UIKit
import Alamofire
import RealmSwift

class UserController: BaseViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var savedUserTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var getList = "/api?results=50"
    var data = [ResultModel]()
    
    let realm = try! Realm()
    
    let array = [ResultModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        savedUserTableView.delegate = self
        savedUserTableView.dataSource = self
        
        UserTableViewCell.registerIn(userTableView)
        UserTableViewCell.registerIn(savedUserTableView)
        savedUserTableView.isHidden = true
        fetchData()
        
        realm.beginWrite()
        realm.delete(realm.objects(User.self))
        try! realm.commitWrite()
    }
    
    func fetchData() {
        NetWorkService.request(url: getList, method: .get, param: nil, encoding: JSONEncoding.default) { (response: ResponseModel) in
            self.data = response.results
            self.userTableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            savedUserTableView.isHidden = true
            userTableView.isHidden = false
            userTableView.reloadData()
        default:
            userTableView.isHidden = true
            savedUserTableView.isHidden = false
            indicator.stopAnimating()
            savedUserTableView.reloadData()
        }
    }
}

extension UserController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == userTableView {
            return data.count
        } else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userTableView {
            let cell = userTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            cell.setItems(item: data[indexPath.row])
            return cell
        } else {
            let cell = savedUserTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            let us = realm.objects(User.self)
            cell.userFullName.text = us[indexPath.row].name
            cell.userEmail.text = us[indexPath.row].email
            let image = UIImage(data: us[indexPath.row].photoData! as Data)
            cell.userImage.image = image
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userTableView {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsController") as! UserDetailsController
            vc.name = data[indexPath.row].id?.name ?? ""
            vc.value = data[indexPath.row].id?.value ?? ""
            vc.lat = Double(data[indexPath.row].location?.coordinates?.latitude ?? "")
            vc.lng = Double(data[indexPath.row].location?.coordinates?.longitude ?? "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}