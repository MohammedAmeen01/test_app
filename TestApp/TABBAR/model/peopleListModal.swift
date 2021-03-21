//
//  File.swift
//  TestApp
//
//  Created by Rahul Sharma on 21/03/21.
//

import Foundation

class peopleListModal {
    var totalList = [eachPerson]()
    init(list : [eachPerson]) {
        self.totalList = list
    }
}

struct eachPerson {
    
    var id = ""
    var age = 0
    var email = ""
    var favoriteColor = ""
    var gender = ""
    var lastSeen = ""
    var name = ""
    var phone = ""
    var picture = ""
    
    init(eachid : String, eachage : Int, eachemail : String, eachfavtcolor : String, eachGender : String, eachLastSeen : String, eachname : String, eachphone : String, eachpic : String) {
        
        self.id = eachid
        self.age = eachage
        self.email = eachemail
        self.favoriteColor = eachfavtcolor
        self.gender = eachGender
        self.lastSeen = eachLastSeen
        self.name = eachname
        self.phone = eachphone
        self.picture = eachpic
    }
    
}
