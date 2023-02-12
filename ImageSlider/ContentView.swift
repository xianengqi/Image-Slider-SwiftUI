//
//  ContentView.swift
//  ImageSlider
//
//  Created by Mahdi Mahjoobi on 8/14/21.
//

import SwiftUI

@available(iOS 16, *)
struct ContentView: View {
  var body: some View {
    // 1
    NavigationStack {
      // 2
      VStack {
        List {
          MultiImagePickerView()
            .frame(height: 300)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        } //: List
       
        Section {
          ContentStringView()
        }
      }
    } //: Navigation View
  }
}

@available(iOS 16, *)
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
