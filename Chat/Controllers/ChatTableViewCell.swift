//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by hesham abd elhamead on 11/08/2023.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var unReadedCounterView : UIView!
    @IBOutlet weak var unReadedCounter: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unReadedCounter.layer.cornerRadius = unReadedCounter.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureChatRoom(chatRoom : chatRoom){
        userName.text = chatRoom.recevierName
        lastMessage.numberOfLines = 2
        lastMessage.minimumScaleFactor = 0.9
        userName.minimumScaleFactor = 0.9
        lastMessage.text = chatRoom.lastMessage
        if chatRoom.unReadedCounter != 0{
            self.unReadedCounter.text = "\(chatRoom.unReadedCounter)"
            self.unReadedCounter.isHidden = false
        }
        else{
            self.unReadedCounter.isHidden = true
        }
        if chatRoom.avtarLink != ""{
            fileStorage.downloadImage(imageUrl: chatRoom.avtarLink) { image in
                self.userImage.image = image?.circleMasked
            }
        }
        else {
            userImage.image = UIImage(named: "person")
        }
        date.text = timeElapsed(chatRoom.date ?? Date())
        
    }

}
