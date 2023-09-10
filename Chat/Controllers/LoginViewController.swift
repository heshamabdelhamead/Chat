//
//  ViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 24/06/2023.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPass.isHidden = true
        
        // Do any additional setup after loading the view.
        emailLabel.text = ""
        passwordLabel.text = ""
        passconformLabel.text = " "
        
        textpass.delegate = self
        textEmail.delegate = self
        textConformPass.delegate = self
        edititing()
        
    }
    //MARK: - IBOutlets
    
    // labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passconformLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var resentEmail: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var haveAnAccount: UILabel!
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var forgetPass: UIButton!
    
    
    //MARK: - textarea
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textConformPass: UITextField!
    @IBOutlet weak var textpass: UITextField!
    //MARK: - IBAction
    @IBAction func forgetbutt(_ sender: Any) {
        resetpassword()
    }
    
    @IBAction func resentEmail(_ sender: Any) {
        resentEmailverication()
    }
    
    
    @IBAction func registerbutt(_ sender: Any) {
        if   isDataInputedFor(mode: isLogin ?     "login" : "register" ) {
            //TODO: register OR login
            
            
            isLogin ? loginForButton() : registerForButton()

            
        }

        else {
            ProgressHUD.showError("all fields are requried")
        }
    }
    //MARK: - singOut
    @IBAction func signbutt(_ sender: Any) {
        update(mode: isLogin)
        
    }
    
    
    func update(mode : Bool){
        isLogin.toggle()

        if isLogin{
            titleLabel.text = "login"
            passconformLabel.isHidden = true
            textConformPass.isHidden = true
            register.setTitle("login", for: .normal)
            login.setTitle("register", for: .normal)
            //  login.titleLabel?.font = UIFont.systemFont(ofSize: 12.0) // Set the desired font size
            resentEmail.isHidden = true
            haveAnAccount.text = "Not have a one"
        }

        else{
            titleLabel.text = "register"
            passconformLabel.isHidden = false
            textConformPass.isHidden = false
            resentEmail.isHidden = false
            haveAnAccount.isHidden = false
            register.setTitle("register", for: .normal)
            
            login.setTitle("login", for: .normal)
            // login.titleLabel?.font = UIFont.systemFont(ofSize: 12.0) // Set the desired font size
            
            haveAnAccount.text = "Have an acount?"
            
            
            
            
        }
        forgetPass.isHidden.toggle()
        
       // isLogin.toggle()
    }
    
    
    
    func isDataInputedFor(mode : String)->Bool{
        switch mode{
        case "login" : if textEmail.text != "" && textpass.text != " "{
            return true
        }
            else{ return false }
        case "register" : if textEmail.text != "" && textpass.text != "" && textConformPass.text != ""
            {    return true}
            else{ return false}
            
        case "resent" : if textEmail.text != ""{
            return true
        }
            else {return false}
            
        default :
            return false
        }
        
    }
    //MARK: - resetForgetPassword
    func resetpassword(){
        FUserLisner.shared.resetpassword(email: textEmail.text!) { error in
            if error == nil{
                ProgressHUD.showSucceed("reset password  email has been sent")
            }
            else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    //MARK: - sign
    func loginForButton(){
        FUserLisner.shared.loginUserWith(email: textEmail.text!, Password: textpass.text!) { error, isEmailVerified in
            if error == nil{
                if isEmailVerified{
                    self.goToApp()
                }
                else{
                    ProgressHUD.showFailed("please checK your email and verify your registration")
                }
            }
            
            
            else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        }
    }

    
    //MARK: - register
func registerForButton(){
        if textpass.text! == textConformPass.text! {
            print("hi test")
            
            FUserLisner.shared.registerUserWith(email: textEmail.text!, password: textpass.text!){(error) in
                print(error)
                if error == nil{
                    ProgressHUD.showSucceed("verificantion Email sent,please check your email and verify your eamil")
                }
                else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
                
            }
            
        }
    }
    
    
    
    
    
    //MARK: - resend email verification
    func resentEmailverication(){
        FUserLisner.shared.resendEmailVerification(eamil: textEmail.text!) { error in
            if error == nil{
                ProgressHUD.showSucceed("verification email successfly")
            }
            else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    //MARK: - navigate from the login view to app
    func goToApp(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    

    
}
//MARK: - textDelgate

extension LoginViewController : UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = textEmail.hasText ? "email" : " "
        passwordLabel.text = textpass.hasText ? "password" : " "
        passconformLabel.text = textConformPass.hasText ? "conform  password" : " "
    }
    
    func edititing(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        view.reloadInputViews()
//        //collectionView.collectionViewLayout.invalidateLayout()
//    }
}

