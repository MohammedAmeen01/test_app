//
//  ProfileController.swift
//  TestApp
//
//  Created by Rahul Sharma on 19/03/21.
//

import UIKit
import CoreData

class ProfileController: UIViewController {

    @IBOutlet weak var profilePhoto : UIImageView!
    @IBOutlet weak var nameTF : UITextField!
    @IBOutlet weak var dobTF : UITextField!
    @IBOutlet weak var genderTF : UITextField!
    
    var history = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromCoreDB()
        // Do any additional setup after loading the view.
    }
    

    func fetchDataFromCoreDB() {
        
    guard let appDelegate =
    UIApplication.shared.delegate as? AppDelegate else {
    return
    }
  
    let managedContext =
    appDelegate.persistentContainer.viewContext
    
    let fetchRequest =
    NSFetchRequest<NSManagedObject>(entityName: "Demodata")
    
    do {
    history = try managedContext.fetch(fetchRequest)
    
    for x in history{
    
    let userName = x.value(forKey: "name_db")
        nameTF.text = userName as? String
        
    let userDob = x.value(forKey: "dob_db")
        dobTF.text = userDob as? String
        
    let userGender = x.value(forKey: "gender_db")
        genderTF.text = userGender as? String
    if let userImgData = x.value(forKey: "profilepic_db") as? Data {
        let profileImg = UIImage(data: userImgData)
        profilePhoto.image = profileImg
    }
        
    }
    } catch let error as NSError {
    print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    }

    @IBAction func tappedLogout(_ Sender : UIButton) {
        UserDefaults.standard.set(false, forKey: "isSignedUp")
        deleteAllData(entity: "Demodata")
        self.dismiss(animated: false, completion: nil)
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
