//
//  MemeViewController.swift
//  MemeMaker
//
//  Created by Michael Montoya on 1/29/17.
//  Copyright © 2017 Michael Montoya. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    //==================================================
    // MARK: Properties
    //==================================================
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let memeTextAttributes:[String:Any] = [
        
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
        NSStrokeWidthAttributeName: -1.0
    ]
    
    //     var memes: [Meme]!
    
    //==================================================
    // MARK: Outlets
    //==================================================
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    //==================================================
    // MARK: Lifecycle functions
    //==================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP TEXT HERE"
        bottomTextField.text = "BOTTOM TEXT HERE"
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //==================================================
    // MARK: IB Actions
    //==================================================
    
    
    @IBAction func pictureButtonTapped(_ sender: Any) {
        
        presentPicker(withSource: .photoLibrary)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        presentPicker(withSource: .camera)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        share()
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        memeImageView.image = nil
        topTextField.text = "TOP TEXT HERE"
        bottomTextField.text = "BOTTOM TEXT HERE"
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //==================================================
    // MARK: Functions
    //==================================================
    
    
    func presentPicker(withSource source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        self.present(pickerController, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        
        topNavBar.isHidden = true
        bottomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topNavBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        
        guard let topText = topTextField.text, let bottomText = bottomTextField.text, let originalImage = memeImageView.image else { return }
        
        
        var meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: generateMemedImage())
        
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func share() {
        
        let memedImage = generateMemedImage()
        let ActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.present(ActivityVC, animated: true, completion: nil)
        ActivityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //==================================================
    // MARK: Picker Delegate Functions
    //==================================================
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //==================================================
    // MARK: TextField Delegate Functions
    //==================================================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField { topTextField.text = ""
        } else {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //==================================================
    // MARK: Notifications
    //==================================================
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            
            else { return 0 }
        
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide,object: nil)
    }
}
