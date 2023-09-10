//
//  EditProfileTableViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 08/07/2023.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate{
    var gallery : GalleryController!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFeild()
        tableView.tableFooterView = UIView()
        showUserInfo()
    }

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "statusSegue", sender: self)
            
        }
    }
//MARK: - outlet
    
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    //MARK: - action
    
    @IBAction func editButtoon(_ sender: Any) {
        showGallery()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 : 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTabelView")
        return headerView
    }
    //MARK: - Gallery
    private func showGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [ .imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallery, animated: true)
        userImage.image?.circleMasked
        
    }
    
    
    
    
    //MARK: - configure textfeild
    private func configureTextFeild(){
        userTextField.delegate = self
        userTextField.clearButtonMode = .whileEditing
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextField{
            if textField.text != " "{
                if var user = user.currentUser{
                    user.userName = textField.text!
                    saveUserLocally(user: user)
                    FUserLisner.shared.saveUserTofirestore(user)
                }

            }
            return false

        }
        return true

    }
    
    
    
   //MARK: - show user info
    func showUserInfo(){
        if let user = user.currentUser{
            userTextField.text = user.userName
            userStatusLabel.text = user.status
            if user.avatarLink != ""{
                //   download avtar
                fileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    self.userImage.image = image?.circleMasked
                    
                }
                
            }
        }
    }
    
    //MARK: - uploadImage
    private func uploadimage (_ image : UIImage){
        let fileDierectory = "Avatars/" + "_\(user.curentId)" + ".jpg"
        fileStorage.uploadImage(image, directory: fileDierectory) { imageLink in
            if var user = user.currentUser{
                user.avatarLink = imageLink!
                saveUserLocally(user: user)
                FUserLisner.shared.saveUserTofirestore(user)
            }
            
            // save image locally
            
            
            fileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: user.curentId)
        }
    }
   
    
    
    

    
}

extension EditProfileTableViewController : GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0{
            images.first!.resolve { userImage in
                if userImage != nil{
                    self.uploadimage(userImage!)
                    self.userImage.image = userImage
                
                }
                else{
                    ProgressHUD.showError("could not select image")
                }
            }
        }
        controller.dismiss(animated: true)

    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true)

    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)

    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)
    }
    
    
}
