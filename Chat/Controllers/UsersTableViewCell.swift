//
//  UsersTableViewCell.swift
//  Chat
//
//  Created by hesham abd elhamead on 30/07/2023.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureCell(user : user){
        userStatus.text = user.status
        userName.text = user.userName
        if user.avatarLink != ""{
            fileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                self.userImage.image = image?.circleMasked
            }
            
        }
    }

}
