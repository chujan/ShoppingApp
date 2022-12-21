//
//  RegisterViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 09/12/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.clipsToBounds = true
           return scrollView
           
       }()
    
    private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.circle")
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            return imageView
            
        }()
    private let usernameField: UITextField = {
           let field = UITextField()
           field.placeholder = "Username or Email..."
           field.returnKeyType = .next
           field.leftViewMode = .always
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.layer .masksToBounds = true
           field.backgroundColor = .secondarySystemBackground
           field.layer.borderWidth = 1.0
           field.layer.borderColor = UIColor.secondaryLabel.cgColor
           field .layer.cornerRadius = 8
           return field
           
           
       }()
       

   
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
          // field.isSecureTextEntry = true
           return field
           
       }()
    
    private let RegisterButton: UIButton = {
            let button = UIButton()
            button.setTitle("Sign up", for: .normal)
            button.backgroundColor = .systemGreen
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            return button
        }()
       
       
  

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(RegisterButton)
        emailField.delegate = self
        passwordField.delegate = self
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
       
        
        view.backgroundColor = .systemBackground
       
        
    }
    @objc private func didTapChangeProfilePic() {
            presentPhotoActionSheet()
            
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                         y: 20,
                                         width: size,
                                         height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
                
        
        usernameField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        emailField.frame = CGRect(x: 30, y: usernameField.bottom+10, width: scrollView.width-60, height: 52)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        RegisterButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        RegisterButton.addTarget(self, action: #selector(self.RegisterButtonTapped), for: .touchUpInside)
        
    }
    func alertUserLoginError(message: String = "Please enter all informaton to create a new account.") {
           
           let alert = UIAlertController(title: "Woops",
                                         message: "Please enter all information to create a new account", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
           
           present(alert, animated: true)
           
       }
    @objc private func RegisterButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let userName = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              !userName.isEmpty,
              password.count >= 6 else {
            return
        }
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists")
                return
            }
            
        })
        
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard  authResult != nil, error == nil else {
                print("Error creating user")
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.setValue("\(userName)", forKey: "name")
            let chatUser = ChatAppUser(userName: userName, emailAddress: email)
            DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                if success {
                    guard let image = self.imageView.image,
                          let data = image.pngData() else  {
                        return
                    }
                    let filename = chatUser.profilePictureFileName
                    StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                        switch result {
                        case .success(let downloadurl):
                            UserDefaults.standard.set(downloadurl, forKey: "profile_picture_url")
                            print(downloadurl)
                        case .failure(let error):
                            print("Storage manager error: \(error)")
                        }
                        
                    })
                   
                }

            })
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    


}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailField {
                passwordField.becomeFirstResponder()
            }
            else if textField == passwordField {
                RegisterButtonTapped()
            }
            return true
        }

}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self]_ in
                                                self?.presentCamera()
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self]_ in
                                                self?.presentPhotoPicker()
                                                
                                            }))
        
        present(actionSheet, animated: true)
        
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}
    




    
