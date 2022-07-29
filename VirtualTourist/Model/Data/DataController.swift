//
//  DataController.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 6/30/22.
//

import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion: (() -> Void)? = nil) {
            persistentContainer.loadPersistentStores{ storeDescription, error in
                guard error == nil else{
                    fatalError(error!.localizedDescription)
                }
                self.autoSaveViewContext()
                self.configureContexts()
                completion?()
            }
        }
    // save current context
    func save() throws{
        if viewContext.hasChanges{
            try viewContext.save()
        }
    }
    
    static let shared = DataController(modelName: "VirtualTourist")
}

// MARK: Autosaving

extension DataController {
    
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else{
            print("cannot set negative autosave interval")
            return
        }
        // we discard any error, just let the method try again at the next interval
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}

extension DataController {
    
    func fetchLocation(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil) throws-> Pin? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = predicate
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let location = (try viewContext.fetch(fetchRequest) as! [Pin]).first else {
            return nil
        }
        return location
    }
    
    func fetchAllLocation() throws-> [Pin]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let pin = try viewContext.fetch(fetchRequest) as? [Pin] else {
            return nil
        }
        return pin
    }

    func fetchAllPhoto(_ predicate: NSPredicate? = nil, sorting: NSSortDescriptor? = nil) throws-> [Photo]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = predicate
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let allPhoto = try viewContext.fetch(fetchRequest) as? [Photo] else {
            return nil
        }
        return allPhoto
    }
    
}
