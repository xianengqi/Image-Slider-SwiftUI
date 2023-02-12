//
//  ContentStringView.swift
//  ImageSlider
//
//  Created by 夏能啟 on 2023/2/12.
//

import SwiftUI

@available(iOS 16, *)
struct ContentStringView: View {
  @EnvironmentObject var imagePicker: ImagePicker
  @FetchRequest(entity: DBString.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], animation: .default)
  var inData: FetchedResults<DBString>
 
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  @State private var title = ""
  
  private func deleteString(offsets: IndexSet) {
    withAnimation {
      offsets.map{ inData[$0] }.forEach(managedObjContext.delete)
      CoreDataStack().save(context: managedObjContext)
    }
  }

  var body: some View {
    VStack {
     Spacer()
      if !inData.isEmpty {
       
          List {
            ForEach(inData) { item in
              
              Text(item.title ?? "")
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .contextMenu {
                  Button("Delete") {
                    Task {
                      await imagePicker.deleteStringT(for: item.objectID)
                    }
                  }
                }
            }
          }
          
        
       
      } else {
        Text("请在下方蓝色区域输入文字")
      }
        TextField("请输入", text: $title)
        .foregroundColor(Color.white)
        .background(Color.teal)
        
      
    }
    VStack {
      Button(action: {
        print("请输入\(title)")
       
        CoreDataStack().add(title: title, context: managedObjContext)
        self.title = ""
      }, label: {
        Text("保存")
      })
    }
  }
}

@available(iOS 16, *)
struct ContentStringView_Previews: PreviewProvider {
  static var previews: some View {
    ContentStringView()
  }
}
