//
//  ChatViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 10/12/2022.
//

import UIKit
import SDWebImage
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
struct Message: MessageType {
    public var sender: SenderType
    
  public  var messageId: String
    
 public   var sentDate: Date
    
  public  var kind: MessageKit.MessageKind
    

}

struct Media: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    
}

//struct Message: MessageType {
//    public var sentDate: Date
//
//   public  var kind: MessageKind
//
//    public var sender: SenderType
//   public var messageId: String
//}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_Preview"
        case .custom(_):
            return "custom"
        }
    }
}
struct Sender: SenderType {
   public var PhotoUrl: String
   public var senderId: String
    
  public  var displayName: String
    
    
}


class ChatViewController: MessagesViewController {
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    
    
    public let otherUserEmail: String
    private var conversationId: String?
    public var isNewConversation = false
    private var messages = [Message]()
    private var selfSender :Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
            
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
       return Sender(PhotoUrl: "", senderId: safeEmail , displayName: "Me")
    }
    
    init(with email: String, id: String? ) {
        self.otherUserEmail = email
        self.conversationId = id
        super.init(nibName: nil, bundle: nil)
        if let conversationId = conversationId {
            listenForMessage(id: conversationId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .systemBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
      
        
        
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
    }
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo", message: "Where would you like to attach a photo from", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
          
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: { _ in
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil
            
            
        ))
        present(actionSheet, animated: true)
        
        
    }
    
    private func presentInputPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media", message: "What would you like to attach?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
           
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: {  _ in
            
            
        }))
       
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:   nil
            
            
        ))
        present(actionSheet, animated: true)
        
        
    }
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
       
        if let conversationId = conversationId {
            listenForMessage(id: conversationId)
        }
    }
    
    private func listenForMessage(id: String) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case.success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
                
                
            case.failure(let error):
                print("failed to get messages: \(error)")
            }
            
        })
        
    }
    

   

}
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
        let imageData = image.pngData(),
        let messageId = createMessageId(),
        let conversationId = conversationId,
        let name = self.title,
        let selfSender = selfSender else {
            return
        }
        let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
        StorageManager.shared.uploadmessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
            guard let strongSelf  = self else {
                return
            }
            switch result {
            case.success(let urlString):
               print("upload message photo: \(urlString)")
                guard let url = URL(string: urlString),
                      let placeholder = UIImage(systemName: "plus") else {
                    return
                }
                
                let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
                
                let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .photo(media))
                
                DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                    if success {
                        print("sent photo mesage")
                    }
                    else {
                        print("failed to send photo message")
                    }
                    
                })
                
            case.failure(let error):
                print("message photo upload error:\(error)")
            }
            
        })
    }
    
}
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender =  selfSender,
              let messageId = createMessageId() else {
            
            return
        }
        print("sending: \(text)")
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        if isNewConversation {
            DatabaseManager.shared.createNewConversations(with: otherUserEmail, name: self.title ?? "User" , firstMessage: message, completion: { [weak self] success in
                
                if success {
                    print("message sent")
                    self?.messageInputBar.inputTextView.resignFirstResponder()
                    self?.isNewConversation = false
                    let newConversationId = "conversationId_\(message.messageId)"
                    self?.conversationId = newConversationId
                   // self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                }
                
                else {
                    print("failed to send")
                }
                
                
            })
            
        }
        else {
            guard let conversationId = conversationId, let name = self.title else {
                return
            }
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail,  name: name, newMessage: message, completion: {[weak self] success in
                if success {
                    print(success)
                    self?.messageInputBar.inputTextView.resignFirstResponder()
                    self?.messageInputBar.inputTextView.text = nil
                    print("message sentb")
                }
                else {
                    print("failed to sent")
                }
                
            })
            
        }
           

    }

    private func createMessageId() -> String? {
        
        
       guard let currentUserEmail = UserDefaults.standard.value(forKey: "email")
                as? String else  {
            return nil
        }
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        print("created message id: \(newIdentifier)")
        return newIdentifier
        
    }
    
}


extension ChatViewController: MessagesDataSource,MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
            
        }
      // return Sender(PhotoUrl: "", senderId: "12", displayName: "")
        fatalError("self sender is nil, email should be catched")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
      
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
        
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        switch message.kind {
        case.photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    
    
}

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexPath.section]
        
        switch message.kind {
        case.photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
