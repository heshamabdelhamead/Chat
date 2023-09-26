//
//  chatRoomTableViewTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 11/08/2023.
//

import UIKit

class chatRoomTableViewTableViewController: UITableViewController {
    
    var chatRooms :[chatRoom] = []
    var filterChatRooms : [chatRoom] = []
    let searchController = UISearchController(searchResultsController: nil)

    @IBAction func compose(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "users") as! UserTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadChatRoom()
        tableView.tableFooterView = UIView()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "search user"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        self.refreshControl = UIRefreshControl()
        
        self.tableView.refreshControl = refreshControl
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            var  chatRoom = searchController.isActive ? filterChatRooms[indexPath.row] : chatRooms[indexPath.row]
            FChatRoomListener.shared.delelt(chatRoom: chatRoom)
            searchController.isActive   ? filterChatRooms.remove(at: indexPath.row) : chatRooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filterChatRooms.count :  chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
//        let chatRoom = chatRoom(id: "123", chatRoomId: "123", senderName: "123", recevierId: "123", recevierName: "ali", date: Date(), membersIds: [""], lastMessage: "hello ay beh", unReadedCounter: 1, avtarLink: "")
        
        cell.configureChatRoom(chatRoom: chatRooms[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func downloadChatRoom(){
        FChatRoomListener.shared.downloadAllChatRooms { chatRoom in
            self.chatRooms = chatRoom
           DispatchQueue.main.async {
              self.tableView.reloadData()
           }
        }
    }

}


extension chatRoomTableViewTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        filterChatRooms = chatRooms.filter({ chatRoom in
            return chatRoom.recevierName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var  objectChatRoom = searchController.isActive ? filterChatRooms[indexPath.row] : chatRooms[indexPath.row]
        goToMessage(objectChatRoom)
    }
    
    
    func  goToMessage( _ chatRoom : chatRoom){
        //MARK: if two users have chaat room
        
        restartChat(chatRoomId: chatRoom.id, memberIds: chatRoom.membersIds)
        
        let vc = MSViewController(chatId: chatRoom.chatRoomId, recipienttId: chatRoom.recevierId, recipientName : chatRoom.recevierName)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

