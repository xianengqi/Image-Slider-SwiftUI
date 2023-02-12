//
//  CoreDataStack.swift
//  ImageSlider
//
//  Created by 夏能啟 on 2023/2/11.
//

import CoreData
import Foundation

@available(iOS 16, *)
final class CoreDataStack: ObservableObject {
  let container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ModelImages")
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Load model error: \(error.localizedDescription)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
  
  var viewContext: NSManagedObjectContext {
    container.viewContext
  }
  
  init() {}
  
  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data Saved")
    } catch {
      print("Couldn't save the data")
    }
  }
  
  func saveImage(data: Data) async {
    await container.performBackgroundTask { context in
      let image = DBImage(context: context)
      image.imageData = data
      image.timestamp = .now
      do {
        try context.save()
      } catch {
        print("Save image to DB error: \(error.localizedDescription)")
      }
    }
  }
  
  func add(title: String, context: NSManagedObjectContext) {
    let titleData = DBString(context: context)
    titleData.id = UUID()
    titleData.title  = title
    titleData.date = Date()
    
    save(context: context)
  }
  
  func deleteTitle(for id: NSManagedObjectID) async {
    await container.performBackgroundTask{ context in
      guard let dataString = try? context.existingObject(with: id) as? DBString else {
        print("Get ID form DB error")
        return
      }
      context.delete(dataString)
      do {
        try context.save()
      } catch {
        print("Delete string from DB error: \(error.localizedDescription)")
      }
    }
  }
  
  func deleteImage(for id: NSManagedObjectID) async {
    await container.performBackgroundTask { context in
      guard let image = try? context.existingObject(with: id) as? DBImage else {
        print("Get ID form DB error")
        return
      }
      context.delete(image)
      do {
        try context.save()
      } catch {
        print("Delete image from DB error: \(error.localizedDescription)")
      }
    }
  }
}
