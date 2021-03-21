//
//  ListController.swift
//  TestApp
//
//  Created by Rahul Sharma on 20/03/21.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import CoreData



// data from core db
var likedIdsArr = [String]()
var likedProfilePicArr = [String]()
var likedgenderArr = [String]()
var likedAgeArr = [Int]()
var likedColorArr = [String]()
var likedEmailArr = [String]()
var likedPhoneArr = [String]()
var likedNameArr = [String]()


class ListController: UIViewController {
    
    @IBOutlet weak var peopleTbl:UITableView!
    
    let peopleVM = peopleListVM()
    let disposebag = DisposeBag()
    
    var peopleData:peopleListModal!
    var likedProfilesid = [Int]()
    
    
    
    var history = [NSManagedObject]()
    var ismaleProfiles = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleTbl.tableFooterView = UIView()
        peopleVM.getPeopleListAPICall()
        peopleVM.getPeopleList_Response.subscribe(onNext: { [self]response in
            self.peopleData = response
            self.peopleTbl.reloadData()
            self.likedProfilesid.removeAll()
            for _ in self.peopleData.totalList {
                self.likedProfilesid.append(0)
            }
            self.fetchLikedDataFromCoreDB()
            
        }, onError: {error in
            
        }).disposed(by: disposebag)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
            
            if likedIdsArr.count > 0 {
                for x in 0 ..< likedIdsArr.count  {
                    for y in 0 ..< peopleData.totalList.count {
                        if likedIdsArr[x] == peopleData.totalList[y].id {
                            likedProfilesid[y] = 1
                        }
                    }
                }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    @IBAction func segmentChanged(_ Sender : UISegmentedControl) {
        print(Sender.selectedSegmentIndex)
        switch Sender.selectedSegmentIndex
        {
        case 0:
            print("male")
            self.ismaleProfiles = true
            self.peopleTbl.reloadData()
        case 1:
            print("female")
            self.ismaleProfiles = false
            self.peopleTbl.reloadData()
        default:
            break
        }
    }
    //    Likedprofiles
    @objc func tappedLike(_ Sender : UIButton) {
        if Sender.isSelected {
            likedProfilesid[Sender.tag] = 0
            deleteLikedProfileFromdb(id : peopleData.totalList[Sender.tag].id)
        } else {
            likedProfilesid[Sender.tag] = 1
            savelikedprofilestodb(id : peopleData.totalList[Sender.tag].id)
           
        }
        
        peopleTbl.reloadData()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func savelikedprofilestodb(id : String) {
        
        let date = "\(Date())"
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Likedprofiles", in: managedContext )
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        for i in 0 ..< likedProfilesid.count {
            if id ==  peopleData.totalList[i].id {
                item.setValue(peopleData.totalList[i].age, forKey: "likedAge")
                item.setValue(peopleData.totalList[i].favoriteColor, forKey: "likedColor")
                item.setValue(peopleData.totalList[i].email, forKey: "likedEmail")
                item.setValue(peopleData.totalList[i].name, forKey: "likedName")
                item.setValue(peopleData.totalList[i].phone, forKey: "likedPhone")
                item.setValue(peopleData.totalList[i].picture, forKey: "likedPicture")
                item.setValue(peopleData.totalList[i].id, forKey: "likedid")
                item.setValue(peopleData.totalList[i].gender, forKey: "likedGender")
                
            }
        }
        
        
        
        
        do{
            try managedContext.save()
            print("saved succesfully")
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func deleteLikedProfileFromdb(id : String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likedprofiles")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            //            for managedObject in results
            //            {
            //                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            //                managedContext.delete(managedObjectData)
            //            }
            for x in results
            {
                let managedObjectData:NSManagedObject = x as! NSManagedObject
                let eachid = managedObjectData.value(forKey: "likedid")
                
                if eachid as! String == id {
                    managedContext.delete(managedObjectData)
                }
        
                
            }
            
        } catch let error as NSError {
            
            
        }
        
        
        do{
            try managedContext.save()
            print("saved succesfully")
            
        }catch let error as NSError{
            print(error)
        }
        
    }
}

extension ListController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let x = peopleData {
            return peopleData.totalList.count
        } else {
            return 0
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eachProfileCell") as! eachProfileCell
        cell.profileNameLbl.text = peopleData.totalList[indexPath.row].name
        cell.ageLbl.text = "Age " + "\(peopleData.totalList[indexPath.row].age)"
        cell.profileGenderLbl.text = peopleData.totalList[indexPath.row].gender
        cell.profileEmailLbl.text = peopleData.totalList[indexPath.row].email
        cell.profilePhoneLbl.text = peopleData.totalList[indexPath.row].phone
        cell.profileFvtColorLbl.text = "favt color" + peopleData.totalList[indexPath.row].favoriteColor
        cell.likedBtn.tag = indexPath.row
        
        if likedProfilesid[indexPath.row] == 0 {
            cell.likedBtn.isSelected = false
        } else {
            cell.likedBtn.isSelected = true
        }
        
        cell.likedBtn.addTarget(self, action: #selector(tappedLike(_:)), for: .touchUpInside)
        DispatchQueue.main.async {
            cell.profilePicIV.kf.setImage(with: URL(string: self.peopleData.totalList[indexPath.row].picture),
                                       placeholder:#imageLiteral(resourceName: "default_img"),
                                       options: [.transition(ImageTransition.fade(1))],
                                       progressBlock: { receivedSize, totalSize in
         },
                                       completionHandler: { res in
                                         
         })
        }
        
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if ismaleProfiles {
            if peopleData.totalList[indexPath.row].gender == "male" {
                return 160
            } else {
                return 0
            }
        } else {
            if peopleData.totalList[indexPath.row].gender == "female" {
                return 160
            } else {
                return 0
            }
        }
    }
}
