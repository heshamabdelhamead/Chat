//
//  profileTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 02/08/2023.
//

import UIKit

class profileTableViewController: UITableViewController {
    
    var User : user?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.largeTitleDisplayMode = .never
        self.title = User!.userName
        
        if User != nil {
            self.title = User?.userName
            
            userStatus.text = User?.status
            userName.text = User?.userName
            if User!.avatarLink != ""{
                fileStorage.downloadImage(imageUrl: User!.avatarLink) { image in
                    self.userImage.image = image?.circleMasked
                }
            }
        }
        
        
        
        

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            print("create chat room")
            
            let cahtId = startChat(sender : user.currentUser! , receiver : User!)
            
            let vc = MSViewController(chatId: cahtId, recipienttId: User!.id, recipientName: User!.userName)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTabelView")
        return headerView
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
     return   0.0
    }
   
    
    

   
}
