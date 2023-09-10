//
//  statusTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 29/07/2023.
//

import UIKit

class statusTableViewController: UITableViewController{
    let status = ["busy"," working"," unavilabel","sleeping"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()


        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return status.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = status[indexPath.row]
        let userStatus = user.currentUser?.status
        cell?.accessoryType = userStatus == status[indexPath.row] ? .checkmark : .none
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let userStaus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.reloadData()
        var user = user.currentUser
        user?.status = userStaus!
        saveUserLocally(user: user!)
        FUserLisner.shared.saveUserTofirestore(user!)
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(named: "ColorTabelView")
    
        return header
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    

}
