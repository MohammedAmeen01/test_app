//
//  LikedProfileVC.swift
//  TestApp
//
//  Created by Rahul Sharma on 21/03/21.
//

import UIKit
import Kingfisher
import CoreData

class LikedProfileVC: UIViewController {

    @IBOutlet weak var likedTbl : UITableView!
    
    var history = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.likedTbl.tableFooterView = UIView()
        likedTbl.delegate = self
        likedTbl.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchLikedDataFromCoreDB()
    }
    
    
    func fetchLikedDataFromCoreDB() {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Likedprofiles")
        
        do {
            history = try managedContext.fetch(fetchRequest)
            likedIdsArr.removeAll()
            likedProfilePicArr.removeAll()
            likedgenderArr.removeAll()
            likedAgeArr.removeAll()
            likedColorArr.removeAll()
            likedEmailArr.removeAll()
            likedPhoneArr.removeAll()
            likedNameArr.removeAll()
            
            
            for x in history{
                let likedUserid = x.value(forKey: "likedid")
                let likedage = x.value(forKey: "likedAge")
                let likedcolor = x.value(forKey: "likedColor")
                let likedemail = x.value(forKey: "likedEmail")
                let likedname = x.value(forKey: "likedName")
                let likedphone = x.value(forKey: "likedPhone")
                let likedProfilePic = x.value(forKey: "likedPicture")
                let likedGender = x.value(forKey: "likedGender")
                
                
                likedIdsArr.append(likedUserid as! String)
                likedProfilePicArr.append(likedProfilePic as! String)
                likedgenderArr.append(likedGender as! String)
                likedAgeArr.append(likedage as! Int)
                likedColorArr.append(likedcolor as! String)
                likedEmailArr.append(likedemail as! String)
                likedPhoneArr.append(likedphone as! String)
                likedNameArr.append(likedname as! String)
                
                
            }
            
            if likedIdsArr.count == 0 {
                DispatchQueue.main.async {
                    Helper.alertVC(title: "", message: "no profiles liked", sender: self)
                }
            }
            
            self.likedTbl.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

    
    
}

extension LikedProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedProfilePicArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eachProfileCell") as! eachProfileCell
        cell.profileNameLbl.text = likedNameArr[indexPath.row]
        cell.ageLbl.text = "Age " + "\(likedAgeArr[indexPath.row])"
        cell.profileGenderLbl.text = likedgenderArr[indexPath.row]
        cell.profileEmailLbl.text = likedEmailArr[indexPath.row]
        cell.profilePhoneLbl.text = likedPhoneArr[indexPath.row]
        cell.profileFvtColorLbl.text = "favt color" + likedColorArr[indexPath.row]
        cell.likedBtn.tag = indexPath.row
        cell.likedBtn.isSelected = true
        cell.likedBtn.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            cell.profilePicIV.kf.setImage(with: URL(string: likedProfilePicArr[indexPath.row]),
                                       placeholder:#imageLiteral(resourceName: "default_img"),
                                       options: [.transition(ImageTransition.fade(1))],
                                       progressBlock: { receivedSize, totalSize in
         },
                                       completionHandler: { res in
                                         
         })
        }
        
       
        return cell
    }
    
    
}
