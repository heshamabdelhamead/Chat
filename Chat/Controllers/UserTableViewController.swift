//
//  UserTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 30/07/2023.
//

import UIKit

class UserTableViewController: UITableViewController {
    var users : [user] = []
    var fliteredUsers : [user]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createDummyUsers()
        // users = [user.currentUser!]
        tableView.tableFooterView = UIView()

        downloadUsers()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "search user"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        self.refreshControl = UIRefreshControl()
        
        self.tableView.refreshControl = refreshControl
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return  searchController.isActive ? fliteredUsers!.count : users.count
        
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 30 : 0.0
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor(named: "ColorTabelView")
//        return headerView
//    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UsersTableViewCell
        
        let user = searchController.isActive ? fliteredUsers![indexPath.row] : users[indexPath.row]
        
        cell.configureCell(user: user)
        
        print ("cell.configureCell(user: users![indexPath.row])")
        return cell
    }
    
    private  func downloadUsers(){
        FUserLisner.shared.downloadAllUsersFromFireStroge { fireStoreallUsers in
            self.users = fireStoreallUsers
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                
            }
            print(self.users)
        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing{
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user =  searchController.isActive ? fliteredUsers![indexPath.row] : users[indexPath.row]
      //  performSegue(withIdentifier:"profileSegue" , sender: self)
        showUserProfile(user : user)
        
        }
    func showUserProfile(user : user){
        let userProfile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"userProfile" ) as! profileTableViewController
        
        userProfile.User = user
        navigationController?.pushViewController(userProfile, animated: true)
    }
        
    }





extension UserTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        fliteredUsers = users.filter({ user in
            return user.userName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
    
}
