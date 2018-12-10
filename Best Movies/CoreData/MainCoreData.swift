//
//  MainCoreData.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import CoreData

enum ErrorCoreData:Error {
    case notSave
}

class MainCoreData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context:NSManagedObjectContext = {
        return self.appDelegate.persistentContainer.viewContext
    }()
    
    func saveDatabase() throws{
        do {
            try self.context.save()
        } catch  {
            throw ErrorCoreData.notSave
        }
    }
}
