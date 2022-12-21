//
//  LoginViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 08/12/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
   
    
    private let passwordField: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .done
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "Password..."
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0 ))
           field.leftViewMode = .always
           field.backgroundColor = .secondarySystemBackground
           field.isSecureTextEntry = true
           return field
           
       }()
    
    private let loginButton: UIButton = {
            let button = UIButton()
            button.setTitle("Log In", for: .normal)
            button.backgroundColor = .link
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            return button
        }()
         private let createAccountButton: UIButton = {
           let button = UIButton()
           button.setTitleColor(.label, for: .normal)
           button.setTitle("New User? Create an Account", for: .normal)
           return button
           
           
       }()
    private var loginObserver: NSObjectProtocol?
        
       
  

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        title = "Log In"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        })
        
        
    }
    deinit {
           if let observer = loginObserver {
               NotificationCenter.default.removeObserver(observer)
           }
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+100, width: view.width-40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 52)
        loginButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 52)
        createAccountButton.frame = CGRect(x: 20, y: loginButton.bottom+10, width: view.width-40, height: 52)
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
    }
    @objc private func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else  {
                print("Failed to log im user with email: \(email)")
                return
            }
            let user = result.user
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case.success(let data):
                    guard let userData = data as? [String: Any],
                          let userName = userData["user_name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set("\(userName)", forKey: "name")
                case.failure(let error):
                    print("failed to read data with error\(error)")
                }
                
            })
            UserDefaults.standard.set(email, forKey: "email")
          
            print("Logged In user: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    func alertUserLoginError() {
            let alert = UIAlertController(title: "Woops",
                                          message: "Please enter all information to log in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            
        }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    


}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }

}
