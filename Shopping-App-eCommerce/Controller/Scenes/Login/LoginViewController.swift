//
//  LoginViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Avinash on 1.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var imagecheck: UIImageView!
    private var authUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        setupWithStroyboard()
       
    }
    //MARK: - Interaction handlers
    
    @IBAction func rememberME(_ sender: UIButton) {
        if imagecheck.image == #imageLiteral(resourceName: "unchecked"){
            imagecheck.image = #imageLiteral(resourceName: "checked")
        }else if UserDefaults.standard.object(forKey: "rememberMeDetails") == nil{
            imagecheck.image = #imageLiteral(resourceName: "unchecked")
        }
        else{
            self.imagecheck.image = #imageLiteral(resourceName: "unchecked")
        }
        
    }
    
    
    @IBAction func GuestMode(_ sender: UIButton) {
        
        Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
                    DuplicateFuncs.alertMessage(title: "Guest Mode Error", message: error.localizedDescription, vc: self)
                } else {
                    print("Guest user signed in successfully")
                    self.deleteGuestUserData() // Delete any existing guest user data

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.homeVC) as! HomeViewController
                    homeVC.someBoolProperty = true // Replace true with your boolean value
                    self.show(homeVC, sender: self)
                }
            }
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if self.imagecheck.image == #imageLiteral(resourceName: "unchecked"){
                    UserDefaults.standard.removeObject(forKey: "rememberMeDetails")
                }else {
                   
                    UserDefaults.standard.set(["username":self.emailTextField.text!,"password":self.passwordTextField.text!], forKey: "rememberMeDetails")
                   
                }
                if let e = error {
                    DuplicateFuncs.alertMessage(title: "ERROR", message: e.localizedDescription, vc: self)
                } else {
                    if self.isEmailVerified() {
                        DuplicateFuncs.alertMessage(title: "Email not verified", message: "Please verify your e-mail", vc: self)
                    } else {
                        self.performSegue(withIdentifier: K.Segues.loginToHome, sender: self)
                    }
                }
            }
        }
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    func setupWithStroyboard(){
        if let rememberMeDetails = UserDefaults.standard.value(forKey: "rememberMeDetails") as? [String:String],let password =  rememberMeDetails["password"] ,let email = rememberMeDetails["username"]{
            self.emailTextField.text = email
            self.passwordTextField.text = password
            
        }
        
    }

    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.loginToForgot, sender: self)

    }
    
    
    //MARK: - Functions
    func isEmailVerified() -> Bool {
        if authUser != nil && !authUser!.isEmailVerified { //buradaki 'isEmailVerified' Firebase'den geliyor.
            // User is available, but their email is not verified.
            return true
        }
        return false
    }
    
    func isCurrentUserGuest() -> Bool {
            return Auth.auth().currentUser?.isAnonymous ?? false
        }

    func deleteGuestUserData() {

        let userId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let guestDataCollection = db.collection("guestData").document(userId!)

        guestDataCollection.delete { error in
            if let error = error {
                print("Error deleting guest user data: \(error.localizedDescription)")
            } else {
                print("Guest user data deleted successfully")
            }
        }
    }
}

