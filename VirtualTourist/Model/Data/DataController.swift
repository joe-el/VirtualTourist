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
    // Save current context—
    func save() throws{
        if viewContext.hasChanges{
            try viewContext.save()
        }
    }
    
    static let shared = DataController(modelName: "VirtualTourist")
}

// MARK: - Autosaving

extension DataController {
    
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else{
            print("cannot set negative autosave interval")
            return
        }
        // We discard any error, just let the method try again at the next interval—
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
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let location = (try viewContext.fetch(fr) as! [Pin]).first else {
            return nil
        }
        return location
    }
    
    func fetchAllLocation() throws-> [Pin]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let pin = try viewContext.fetch(fr) as? [Pin] else {
            return nil
        }
        return pin
    }

    func fetchAllPhoto(_ predicate: NSPredicate? = nil, sorting: NSSortDescriptor? = nil) throws-> [Photo]? {
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            fr.predicate = predicate
            if let sorting = sorting {
                fr.sortDescriptors = [sorting]
            }
            guard let allPhoto = try viewContext.fetch(fr) as? [Photo] else {
                return nil
            }
            return allPhoto
    }
    
}