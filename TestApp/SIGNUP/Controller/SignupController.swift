//
//  SignupController.swift
//  TestApp
//
//  Created by Rahul Sharma on 18/03/21.
//

import UIKit
import CoreData

class SignupController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var profilePhoto : UIImageView!
    @IBOutlet weak var nameTF : UITextField!
    @IBOutlet weak var dobTF : UITextField!
    @IBOutlet weak var genderTF : UITextField!
    
    var pickerData: [String] = [String]()
    let imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    
    var  chosenImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        imagePicker.delegate = self
        addDoneButtonOnKeyboard()
        showDatePicker()
        createPickerView()
        pickerData = ["Male", "Female", "Others"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profilePhoto.image = #imageLiteral(resourceName: "default_img")
        nameTF.text = ""
        dobTF.text = ""
        genderTF.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let signedUp = UserDefaults.standard.value(forKey: "isSignedUp") as? Bool {
            if signedUp {
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToMyTab", sender: nil)
                }
            }
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        nameTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        nameTF.resignFirstResponder()
    }
    
    
    func createPickerView() {
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTF.inputAccessoryView = toolBar
        genderTF.inputView = picker
    }
    
    
    @objc func action() {
        view.endEditing(true)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain , target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        dobTF.inputAccessoryView = toolbar
        // add datepicker to textField
        dobTF.inputView = datePicker
        
    }
    
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobTF.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    func alertView() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select option for image", message: "", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            self.cameraButtonAction()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        let galleryAction = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            self.libraryAction()
        }
        actionSheetControllerIOS8.addAction(galleryAction)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    /// camera opened
    func cameraButtonAction() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    /// library opened
    func libraryAction() {
        if  UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.navigationBar.isTranslucent = false
            // Background color
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func noCamera() {
        Helper.alertVC(title: "NoCamera", message: "CameraMissing", sender: self)
        
    }
    
    @IBAction func tappedProfilePhoto(_ Sender : UIButton) {
        alertView()
    }
    
    @IBAction func tappedSignup(_ Sender : UIButton) {
        if nameTF.text?.count == 0 {
            Helper.alertVC(title: "", message: "Enter name", sender: self)
            return
        } else if dobTF.text?.count == 0 {
            Helper.alertVC(title: "", message: "Enter date of birth", sender: self)
            return
        } else if genderTF.text?.count == 0 {
            Helper.alertVC(title: "", message: "Select gender", sender: self)
            return
        } else if chosenImage == nil {
            Helper.alertVC(title: "", message: "Upload profile image", sender: self)
            return
        } else {
            signupProcess()
        }
    }
    
    func signupProcess() {
        
        let date = "\(Date())"
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Demodata", in: managedContext )
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(nameTF.text, forKey: "name_db")
        item.setValue(dobTF.text, forKey: "dob_db")
        item.setValue(genderTF.text, forKey: "gender_db")
        if let imageData = profilePhoto.image?.pngData() {
            item.setValue(imageData, forKey: "profilepic_db")
           }
        
        
        do{
            try managedContext.save()
            print("saved succesfully")
            UserDefaults.standard.set(true, forKey: "isSignedUp")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToMyTab", sender: nil)
               print("next page")
                
            }
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = pickerData[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        chosenImage = info[.editedImage] as? UIImage //2
        chosenImage = Helper.changeImageFrame(with: chosenImage ?? UIImage(), scaledTo: CGSize(width: 100, height: 100))
        profilePhoto.image = chosenImage
        profilePhoto.layer.borderWidth = 1
        dismiss(animated:true, completion: nil) //5
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
           dismiss(animated: true, completion: nil)
    }
}

extension UIView {

  @IBInspectable var cornerRadius: CGFloat {

   get{
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
        return UIColor(cgColor: layer.borderColor!)
    }
    set {
        layer.borderColor = borderColor?.cgColor
    }
  }
}
