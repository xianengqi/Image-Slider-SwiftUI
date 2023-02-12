//
//  ImageSliderApp.swift
//  ImageSlider
//
//  Created by Mahdi Mahjoobi on 8/14/21.
//

import SwiftUI

@available(iOS 16, *)
@main
struct ImageSliderApp: App {
  @StateObject var imagePicker = ImagePicker()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(imagePicker)
            .environment(\.managedObjectContext, imagePicker.stack.viewContext)
        }
    }
}
