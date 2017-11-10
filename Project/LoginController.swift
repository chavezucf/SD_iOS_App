//
//  LoginController.swift
//  Project
//
//  Created by Miguel Chavez on 7/17/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//


import UIKit
import Firebase

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        view.addSubview(logoImageView)
        logoImageView.anchorCenterSuperview()
        view.backgroundColor = UIColor.rbg(red: 44, green: 95, blue: 255)
        return view
    }()
    
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
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSForegroundColorAttributeName: UIColor.rbg(red: 17, green: 154, blue: 237), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        return button
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    func handleLogin() {
        guard let email = emailTextField.text else {return }
        guard let password = passwordTextField.text else {return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user,err ) in
            if let err = err {
                print("Failed to sign in with email", err)
                return
            }
            
            print("it worked" , user?.uid ?? "")
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func handleTextInputChange() {
        let isFormVaild = emailTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormVaild {
            loginButton.backgroundColor = UIColor.rbg(red: 44, green: 95, blue: 255)
            loginButton.isEnabled = true
        }
        else {
            loginButton.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
            loginButton.isEnabled = false
        }
    }
    
    func handleDontHaveAccount() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        print("hello")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 160)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 50)
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        let stackView  = UIStackView(arrangedSubviews: [emailTextField,passwordTextField, loginButton])
        
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.anchor(top:logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, widthConstant: 0, heightConstant: 140)
        
    }
}
