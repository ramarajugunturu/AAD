//
//  SEAttendeesListViewController.swift
//  SEiOS
//
//  Created by Shekhar Gaur on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire

protocol UpdateAttendeeListDelegate {
    func updateAttendeesList(list : Array<Any>)
}
class SEAttendeesListViewController: SEBaseViewController {

    @IBOutlet weak var AttendeesTable: UITableView!
    var userDataSource = Array<SEUserModel>()
    var delegate : UpdateAttendeeListDelegate!
    var selectedAttendee = Array<SEUserModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        self.setBackGroundGradient()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btn_Back_Tapped(_ sender: Any) {
        delegate.updateAttendeesList(list: selectedAttendee)
        dismiss(animated: true, completion: nil)
        
    }
    func getFromLocal() {
        if let path = Bundle.main.path(forResource: "user", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonDict = jsonResult as! Dictionary<String, Any>
                let value = jsonDict["value"] as! Array<Any>
                for item in value {
                    let result =  item as! Dictionary<String, Any>
                    let modObj = SEUserModel()
                    modObj.id = result["id"] as! String
                    modObj.businessPhones = result["businessPhones"] as! Array
                    modObj.displayName = result["displayName"] as! String
                    modObj.givenName = result["givenName"] as? String
                    modObj.jobTitle = result["jobTitle"] as? String
                    modObj.mail = result["mail"] as! String
                    modObj.mobilePhone = result["mobilePhone"] as? String
                    modObj.officeLocation = result["officeLocation"] as? String
                    modObj.preferredLanguage = result["preferredLanguage"] as? String
                    modObj.surname = result["surname"] as? String
                    modObj.userPrincipalName = result["userPrincipalName"] as! String
                    self.userDataSource.append(modObj)
                }
                self.AttendeesTable.reloadData()
            } catch {
                // handle error
            }
        }
    }
    
    func getUserDetails() {
        let url: String = "https://graph.microsoft.com/v1.0/users?$orderby=displayName"
        let headers = ["Content-Type" : "application/json", "Authorization":"Bearer \(SEStoreSharedManager.sharedInstance.accessToken)"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (data) in
            
//            if (data.response?.statusCode)! >= 400 {
//                do {
//                    let response = try JSONSerialization.jsonObject(with: data.data!, options: .allowFragments)
//                    let jsonDict = response as! Dictionary<String, Any>
//                    let error = jsonDict["error"] as! Dictionary<String, Any>
//                    let message = error["message"] as! String
//                    print(message)
//                }catch _ {
//                    print("Somethhin went wrong!")
//                }
//
//            }else{
                do {
                    let response = try JSONSerialization.jsonObject(with: data.data!, options: .allowFragments)
                    let jsonDict = response as! Dictionary<String, Any>
                    let value = jsonDict["value"] as? Array<Any>
                    if value != nil {
                        for item in value! {
                            let result =  item as! Dictionary<String, Any>
                            let modObj = SEUserModel()
                            modObj.id = result["id"] as? String
                            modObj.businessPhones = result["businessPhones"] as? Array
                            modObj.displayName = result["displayName"] as? String
                            modObj.givenName = result["givenName"] as? String
                            modObj.jobTitle = result["jobTitle"] as? String
                            modObj.mail = result["mail"] as? String
                            modObj.mobilePhone = result["mobilePhone"] as? String
                            modObj.officeLocation = result["officeLocation"] as? String
                            modObj.preferredLanguage = result["preferredLanguage"] as? String
                            modObj.surname = result["surname"] as? String
                            modObj.userPrincipalName = result["userPrincipalName"] as? String
                            self.userDataSource.append(modObj)
                        }
                        self.AttendeesTable.reloadData()

                    }
                    } catch _ {
                    print("Somethhin went wrong!")
                }
            //}
        }
    }

}

extension SEAttendeesListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "attendeesListCell"
        var cell : SEAttendeesListCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SEAttendeesListCell?
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("SEAttendeesListCell", owner: nil, options: nil)?[0] as? SEAttendeesListCell
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        UITableViewCell.appearance().backgroundColor = .clear
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        cell?.selectionStyle = .none
        let obbject = userDataSource[indexPath.row]
        cell?.configureCell(name: obbject.displayName)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            let obbj = userDataSource[indexPath.row]
           
            if selectedAttendee.contains(where: { $0.id == obbj.id }) {
                if let index = selectedAttendee.index(where: {$0.id == obbj.id}) {
                    selectedAttendee.remove(at: index)
                    print(selectedAttendee.count)
                }
            } else {
                // not
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            self.selectedAttendee.append(userDataSource[indexPath.row])
        }
    }

}

public class SEUserModel {
    var id : String!
    var businessPhones  : Array<String>!
    var displayName : String!
    var givenName : String!
    var jobTitle : String!
    var mail : String!
    var mobilePhone : String!
    var officeLocation : String!
    var preferredLanguage : String!
    var surname : String!
    var userPrincipalName : String!
}

