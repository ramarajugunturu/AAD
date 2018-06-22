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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var AttendeesTable: UITableView!
    var userDataSource = Array<SEAttendeeUserModel>()
    var filtered = Array<SEAttendeeUserModel>()
    var searchActive : Bool = false
    var delegate : UpdateAttendeeListDelegate!
    var selectedAttendee = Array<SEAttendeeUserModel>()
    var webServiceAPI = SEWebServiceAPI()
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
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func getUserDetails() {
        self.startLoading()
        let url = SEWebserviceClient.attendeesListURL
        webServiceAPI.getAttendeesList(url: url, onSuccess: { (result) in
            if result is Array<SEAttendeeUserModel>{
                self.userDataSource = result as! [SEAttendeeUserModel]
                self.AttendeesTable.reloadData()
                self.stopLoading()
            }else{
                let alertController = UIAlertController(title: "", message: "Error while fetcing users.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }) { (error) in
            let alertController = UIAlertController(title: "", message: "Error while fetcing users.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

extension SEAttendeesListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
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
        if(searchActive){
            let obbject = filtered[indexPath.row]
            cell?.configureCell(name: obbject.displayName)
        } else {
            let obbject = userDataSource[indexPath.row]
            cell?.configureCell(name: obbject.displayName)
        }
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

extension SEAttendeesListViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.trimWhiteSpace()
        if searchString != "", searchString.count > 0 {
            let filterData = userDataSource.filter {
                return $0.displayName?.range(of: searchString, options: .caseInsensitive) != nil
            }
            filtered.removeAll()
            filtered = filterData
        }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.AttendeesTable.reloadData()
    }
}

extension String {
    func trimWhiteSpace() -> String {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }
}
