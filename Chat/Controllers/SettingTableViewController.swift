//
//  SettingTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 07/07/2023.
//

import UIKit

class SettingTableViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameLabelOutlet: UILabel!
    @IBOutlet weak var statusLabelOutlet: UILabel!
    @IBOutlet weak var appVersionLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
      //  largeTitleDisplayMode = .never
    //    UIButton().sizeToFit()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showUserInfo()
        
    }
    
    
    @IBAction func tellFriendButton(_ sender: Any) {
    }
    
    @IBAction func termsOfConditionsButton(_ sender: Any) {
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        signout()
    }
    //MARK: - tabelViewDelegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(named: "ColorTabelView")
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func showUserInfo(){
        if let  user = user.currentUser {
            userNameLabelOutlet.text = user.userName
            statusLabelOutlet.text = user.status
            
            appVersionLabelOutlet.text = " app version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != ""{
             //   download avtar
                                fileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                                    self.avatarImageOutlet.image = image?.circleMasked
                
          }
        }
    }
    
    
    
}
    
    //MARK: - signout
    func signout(){
        FUserLisner.shared.logoutFromUser { error in
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                loginView.modalPresentationStyle = .fullScreen
                self.present(loginView, animated: true)
                
                
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if indexPath.section == 0 && indexPath.row == 0{
           
            performSegue( withIdentifier:"editShowSegue" , sender: self)
       }
       
    }

}
