//
//  ImagePicker.swift
//  ImageSlider
//
//  Created by 夏能啟 on 2023/2/11.
//

import CoreData
import PhotosUI
import SwiftUI

@available(iOS 16, *)
@MainActor
class ImagePicker: ObservableObject {
  let stack = CoreDataStack()

  @Published var imageSelections: [PhotosPickerItem] = [] {
    didSet {
      Task {
        if !imageSelections.isEmpty {
          try await loadTransferable(from: imageSelections)
          imageSelections = []
        }
      }
    }
  }

  func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
    do {
      for imageSelection in imageSelections {
        if let data = try await imageSelection.loadTransferable(type: Data.self) {
          await stack.saveImage(data: data)
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  func deleteImage(for id: NSManagedObjectID) async {
    await stack.deleteImage(for: id)
  }
  
  func deleteStringT(for id: NSManagedObjectID) async {
    await stack.deleteTitle(for: id)
  }
}
