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
    
    var data = [ResultModel]()
    
    var secondData: Results<Info>!
    
    let realm = try! Realm()
    
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
        secondData = realm.objects(Info.self)
        savedUserTableView.tableFooterView = UIView()

    }
    
    func fetchData() {
        HomeService.getList { (resp) in
            switch resp {
            case .success(let model):
                self.data = model
                self.userTableView.reloadData()
                self.indicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
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
            return secondData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userTableView {
            let cell = userTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            cell.setItems(item: data[indexPath.row])
            return cell
        } else {
            let cell = savedUserTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            
            let reversedData = secondData.reversed()[indexPath.row]
            
            cell.setRealmData(data: reversedData)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userTableView {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsController") as! UserDetailsController
            vc.delegate = self
            vc.lat = Double(data[indexPath.row].location?.coordinates?.latitude ?? "")
            vc.lng = Double(data[indexPath.row].location?.coordinates?.longitude ?? "")
            vc.usName = data[indexPath.row].name?.fullName ?? ""
            vc.usEmail = data[indexPath.row].email ?? ""
            vc.usImage = data[indexPath.row].picture?.thumbnail ?? ""
            vc.largeImage = data[indexPath.row].picture?.large ?? ""
            vc.usPhone = data[indexPath.row].phone ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let array = secondData[indexPath.row]
            try! realm.write {
                realm.delete(array)
            }
            self.savedUserTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension UserController: UserDetailsControllerDelegate {
    func pressed(name: String, email: String, image: String) {
        let value = Info(value: [name, email, image])
        try! realm.write {
            if secondData.contains(where: {$0.name == value.name}) {
                alert()
                return
            }
            realm.add(value)
            savedUserTableView.reloadData()
            self.segmentControl.selectedSegmentIndex = 1
            self.userTableView.isHidden = true
            self.savedUserTableView.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (time) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "You already have such a user", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
