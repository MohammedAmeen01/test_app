//
//  peopleListVM.swift
//  TestApp
//
//  Created by Rahul Sharma on 21/03/21.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire

class peopleListVM {
    
    let disposebag = DisposeBag()
    let getPeopleList_Response = PublishSubject<peopleListModal>()
    
    
    func getPeopleListAPICall() {
        let strURL =  "http://www.json-generator.com/api/json/get/ceiNKFwyaa?indent=2"
        guard let urlComponents = URLComponents(string: strURL) else { return }
        RxAlamofire
            .requestJSON(.get, urlComponents, headers: nil)
            .subscribe(onNext: { (r, json) in
                print(json)
                
                var fullList = [eachPerson]()
                if let peopleArr = json as? [[String:Any]] {
                    for item in peopleArr {
                        
                        let eachList : eachPerson = eachPerson(eachid: Helper.strForObj(object:item["_id"]), eachage: Helper.intForObj(object: item["age"]), eachemail: Helper.strForObj(object:item["email"]), eachfavtcolor: Helper.strForObj(object:item["favoriteColor"]), eachGender: Helper.strForObj(object:item["gender"]), eachLastSeen: Helper.strForObj(object:item["lastSeen"]), eachname: Helper.strForObj(object:item["phone"]), eachphone: Helper.strForObj(object:item["name"]), eachpic: Helper.strForObj(object:item["picture"]))
                        fullList.append(eachList)
                    }
                    let peopleTotalList : peopleListModal = peopleListModal.init(list: fullList)
                    self.getPeopleList_Response.onNext(peopleTotalList)
                    
                }
                
            }, onError: {  (error) in
                
                
            }).disposed(by: disposebag)
        
    }
    
}


