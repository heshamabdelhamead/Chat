//
//  MSViewController.swift
//  Chat
//
//  Created by hesham abd elhamead on 19/08/2023.
//

import UIKit
import MessageKit
import RealmSwift
import Gallery
import InputBarAccessoryView

class MSViewController: MessagesViewController {
    //MARK: custmisze Navigation title
    
    let  leftBarButtomView : UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()
    let titleLable :UILabel = {
        let title =  UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
       // title.text =
        return title
        
    }()
    let subTitleLabel : UILabel = {
        let subTitle = UILabel(frame: CGRect(x: 5, y: 22, width: 100, height: 24))
        subTitle.textAlignment = .left
        subTitle.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        subTitle.adjustsFontSizeToFitWidth = true
        return subTitle
        
        
    }()
    
    //MARK: variables
    private var chatId = ""
    private var recipienttId = ""
    private var recipientName = ""
    
    var refreshControler = UIRefreshControl()
    let micButton = InputBarButtonItem()
    
    var curentUser = sender(senderId: user.curentId , displayName: user.currentUser!.userName)
    var MKMessages : [MKMessage] = []
    var allLocalMessages : Results<localMessage>!
    let realm = try! Realm()
    var notificationToken = NotificationToken()
    var maxMessgeNumber = 0
    var minMessageNumber = 0
    var displayingMessages = 0
    var typingCounter = 0
    var  gallerly :  GalleryController!
    var longPressedGesture : UILongPressGestureRecognizer!
    var  audioFileName: String  = " "
    var audioStartTime: Date = Date()
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    

    init(chatId: String = "", recipienttId: String = "", recipientName: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipienttId = recipienttId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        super.viewDidLoad()
        configureLongPressedGestureReconzier()
        configureMSGCollectoionview()
        configurationMegInputBar()
        loadMessage()
        listenForNewMessage()
        configureCustomTitle()
        createTypingObserver()
        navigationItem.largeTitleDisplayMode = .never
        self.messagesCollectionView.scrollToLastItem(animated:true)
         
        // Do any additional setup after loading the view.
        
    }
    private func configureMSGCollectoionview (){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = false
        maintainPositionOnKeyboardFrameChanged  = true
        messagesCollectionView.refreshControl = refreshControler
        
    }
    private func configurationMegInputBar(){
        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.onTouchUpInside { item in
            self.actionAttachmentMessage()
        }
        
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        micButton.setSize(CGSize(width: 30, height: 30), animated: true)
        micButton.addGestureRecognizer(longPressedGesture)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 30.0, animated: false)
        messageInputBar.setStackViewItems([attachButton] , forStack : .left, animated: false)

       
        
        updateMicButtonStatus(show: true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
        
        
    }
    //MARK: configure longPressedgestureReconsizer
    
    private func configureLongPressedGestureReconzier(){
        longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
    }
    
    
    
    
    func updateMicButtonStatus(show : Bool){
      // let micButton = InputBarButtonItem()
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        if show{
            messageInputBar.setStackViewItems([ micButton ], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }
        else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton] , forStack : .right, animated : false)
            messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)

        }
    }
    
    
    //MARK: configure custom navigatiton controller title
    
    
    private func configureCustomTitle(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
        leftBarButtomView.addSubview(titleLable)
        leftBarButtomView.addSubview(subTitleLabel)
        let leftButtonItem = UIBarButtonItem(customView: leftBarButtomView)
        self.navigationItem.leftBarButtonItems?.append(leftButtonItem)
        titleLable.text = self.recipientName
        
    }
    
    @objc func backButtonPressed(){
        //TODO: Remove listeners
        removeListener()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: update typing indicator
    func updateTypingIndcator(show: Bool){
        subTitleLabel.text = show ? "Typing..." : ""
    }
    
    func startTypingIndictor(){
        typingCounter += 1
        FTypeListener.saveTypeIndictor(typing: true, chatRoomId: chatId)
        //stop typing after 1.5 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.stopTypingIndictor()
            
            
        }
        
    }
    func stopTypingIndictor(){
        typingCounter -= 1
        if typingCounter == 0 {
            FTypeListener.saveTypeIndictor(typing: false, chatRoomId: chatId)
        }
    }
    
    func createTypingObserver(){
        FTypeListener.shared.createTypeObserver(chatRoomId: chatId) { isTyping in
            DispatchQueue.main.async {
                self.updateTypingIndcator(show: isTyping)

            }
        }
    }
    
    

    
    
    
        //MARK: ACTIOn
    func send(text: String?,photo: UIImage? ,video : Video?,audio: String?,location : String?, audioDuration : Float = 0.0   ){
        Outgoing.sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, audioDuration: audioDuration, location: location, membersId: [user.curentId,recipienttId])
      //  MSViewController.reloadInputViews(<#T##self: UIResponder##UIResponder#>)
    }
    
    // Record audio and send function
    @objc func recordAndSend(){
        switch longPressedGesture.state{
            
        case .began:
            audioFileName = Date().stringDate()
            audioStartTime = Date()
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            print ("began")
        case .ended:
            AudioRecorder.shared.finshRecording()
            
            if fileExistAtPath(path: audioFileName + ".m4a"){
                let audioDuration = audioStartTime.interval(ofComponent: .second, to: Date())
                send(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil, audioDuration: audioDuration)
            }
            print ("end")

             @unknown default: print("unKnown")
        }
    }
    
    
    
    
    
    
    private func actionAttachmentMessage(){
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoOrVideo = UIAlertAction(title: "camera ", style: .default) { alert in
            self.showImageGallery(camera: true)
            
        }
        let showMedie = UIAlertAction(title: "liberary", style: .default) { alert in
            self.showImageGallery(camera: false )

        }
        let shareLocation = UIAlertAction(title: "location", style: .default) { alert in
            self.send(text: nil, photo: nil, video: nil , audio: nil, location: "location")

        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        showMedie.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey:"image")
        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(showMedie)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancel)
        
        
        self.present(optionMenu, animated: true)

    }
    
    
    //MARK: UIscorlleViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         if refreshControler.isRefreshing{
             if allLocalMessages.count > displayingMessages{
                 self.insertMoreMKMessages()
                 messagesCollectionView.reloadDataAndKeepOffset()
                 
             }
         }
         refreshControler.endRefreshing() 
    }
    
    
    
    
    //MARK: load message
    func loadMessage(){
        let perdiect = NSPredicate(format: "chatRoomId = %@", chatId )
        allLocalMessages = realm.objects(localMessage.self).filter(perdiect).sorted(byKeyPath: "date", ascending: true ) // here
        if allLocalMessages.isEmpty{
            checkForOldMessagesInFirestore()                                                                              /// here
        }
        
        notificationToken = allLocalMessages.observe({ change in
            switch change{
            case  .initial:
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated:true)
            case .update(_, _, let insertions, _) :
                for index in  insertions{
                    self.insertMKMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: true)
                    
                }
            case .error(let errror ):
                print ("error in insertion ", errror.localizedDescription)
            }
        })
      // insertMKMessages()               // it dublicate mk messages
    }
    
    
    
    private func insertMKMessage(localMessage: localMessage){
        let incoming = Incoming(messageViewController: self)
      let MKMessage =  incoming.createMKmessage(localMessage: localMessage)
        self.MKMessages.append(MKMessage)
       displayingMessages += 1
        self.messagesCollectionView.scrollToLastItem(animated:true)

    }

    
    private func insertOlderMKMessage(localMessage: localMessage){
        let incoming = Incoming(messageViewController: self)
      let MKMessage =  incoming.createMKmessage(localMessage: localMessage)
        MKMessages.insert(MKMessage, at: 0)
        displayingMessages += 1
    }
    
    private func insertMKMessages(){
        maxMessgeNumber = allLocalMessages.count - displayingMessages
        minMessageNumber = maxMessgeNumber - 5
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }

        for i in minMessageNumber ..< maxMessgeNumber{

            insertMKMessage(localMessage: allLocalMessages[i])
        }
        
    }
    
    private func insertMoreMKMessages(){
        maxMessgeNumber = minMessageNumber  - 1
        minMessageNumber = maxMessgeNumber - 5
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessgeNumber).reversed(){
            
            insertOlderMKMessage(localMessage: allLocalMessages[i])
        }
    }


    func checkForOldMessagesInFirestore(){
        FMessageListener.Shared.checkForOldMessage(documentId: user.curentId, collectionId: chatId)
    }
    
    
    private func listenForNewMessage(){
        FMessageListener.Shared.listenForNewMessage(doucmentId: user.curentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    
    //MARK: hellpers
    
    private func lastMessageDate()->Date{
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
    }
    private func removeListener(){
        FMessageListener.Shared.removeMessageListener()
        FTypeListener.shared.removeTypingListener()
    
    }
        //MARK: Gallery
    private func showImageGallery(camera : Bool){
        
        gallerly = GalleryController()
        gallerly.delegate = self
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab,.videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30
        self.present(gallerly, animated: true )
        
        
        
    }
    
}

extension MSViewController : GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0{
            images.first!.resolve { image in
                self.send(text: nil, photo: image, video: nil, audio: nil, location: nil)
            }
        }
        
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        self.send(text: nil, photo: nil, video: video, audio: nil, location: nil)

        controller.dismiss(animated: true)

    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)

    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)

    }
    
    
}
