//
//  MultiImagePickerView.swift
//  ImageSlider
//
//  Created by 夏能啟 on 2023/2/11.
//

import PhotosUI
import SwiftUI

@available(iOS 16, *)
struct MultiImagePickerView: View {
  @EnvironmentObject var imagePicker: ImagePicker
  @FetchRequest(entity: DBImage.entity(), sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)], animation: .default)
  var imageDatas: FetchedResults<DBImage>

  let columns = [GridItem(.adaptive(minimum: 100))]
  

  var body: some View {
    NavigationStack {
      VStack {
        if !imageDatas.isEmpty {
          TabView {
            ForEach(imageDatas) { dbImage in
              ImageCell(data: dbImage.imageData)
                .contextMenu {
                  Button("Delete") {
                    Task {
                      await imagePicker.deleteImage(for: dbImage.objectID)
                    }
                  }
                }
            }
          }
          .tabViewStyle(PageTabViewStyle())
        } else {
          Text("Tap the menu bar button to select multiple photos.")
        }
      }
      .padding()
      .navigationTitle("Multiple Picker")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          PhotosPicker(selection: $imagePicker.imageSelections,
                       maxSelectionCount: 10,
                       matching: .images,
                       photoLibrary: .shared()) {
            Image(systemName: "photo.on.rectangle.angled")
              .imageScale(.large)
          }
        }
      }
    }
  }
}

// struct MultiImagePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiImagePickerView()
//    }
// }

struct ImageCell: View {
  let data: Data?
  @State var image: Image?
  var body: some View {
    VStack {
      if let image {
        image
          .resizable()
          .scaledToFit()
      } else {
        ProgressView()
      }
    }
    .onAppear{
      Task {
        if let data, let image = UIImage(data: data) {
          self.image = Image(uiImage: image)
        }
      }
    }
  }
}
