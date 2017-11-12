//
//  SignUpController.swift
//  Project
//
//  Created by Miguel Chavez on 7/15/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
        
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.keyboardType = .phonePad
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    func handleTextInputChange() {
        let isFormVaild = emailTextField.text?.characters.count ?? 0 > 0 &&
            usernameTextField.text?.characters.count ?? 0 > 0 &&
            nameTextField.text?.characters.count ?? 0 > 0 &&
            phoneTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormVaild {
            signUpButton.backgroundColor = UIColor.rbg(red: 44, green: 95, blue: 255)
            signUpButton.isEnabled = true
        }
        else {
            signUpButton.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSForegroundColorAttributeName: UIColor.rbg(red: 17, green: 154, blue: 237), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func handleSignUp() {
        
        // make sure all the data at least has something in it
        guard let email = emailTextField.text, email.characters.count > 0 else {return}
        guard let userName = usernameTextField.text, userName.characters.count > 0 else {return}
        guard let name = nameTextField.text, name.characters.count > 0 else {return}
        guard let phone = phoneTextField.text, phone.characters.count > 0 else {return}
        guard let password = passwordTextField.text, password.characters.count > 0 else {return}
        
        // try to creat a user with email and password
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            // Error in handling the request
            // the user might alread have a profile
            if let err = error {
                print("failed:", err)
                return
            }
            
            print("Succ", user?.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            // compresing the upload data
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            // saving the image under profile_images with a random name to make sure no duplicates ?
            FIRStorage.storage().reference().child("profile_images").child(filename).put(uploadData, metadata: nil, completion: { (metadata, err) in
                
                // Error in handling the request to store
                if let err = err {
                    print("Failed tp upload", err)
                    return
                }
                
                // get the url of the stored item
                guard let profileImageUrl = metadata?.downloadURL ()?.absoluteString else { return}
                
                print ("Succ upload profile Image:", profileImageUrl)
                
                guard let uid = user?.uid else {return}
                
                let dictionaryValues = ["userName": userName, "profileImageUrl": profileImageUrl, "phoneNumber": phone, "email":email, "Name":name]
                let values = [uid: dictionaryValues]
                
                // this will add the information to the database with a dictionary of
                // user information. The parent node as UID.
                FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save info in db", err)
                    }
                    
                    print("Succ to save info in db")
                    //guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    //mainTabBarController.setupViewControllers()
                   //self.dismiss(animated: true, completion: nil)
                })
                
                
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchorCenterXToSuperview()
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 140, heightConstant: 140)
        
        setupInputFields()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView  = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, nameTextField, phoneTextField, passwordTextField, signUpButton])
        
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, widthConstant: 0, heightConstant: 250)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
