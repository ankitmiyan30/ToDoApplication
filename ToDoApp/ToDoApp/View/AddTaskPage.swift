//
//  AddTaskPage.swift
//  ToDoApp
//
//  Created by Anthony Ankit on 20/10/20.
//

import SwiftUI
import CoreData
struct AddTaskPage: View {
    @State var date = Date()
    @State var task = ""
    
    @Environment(\.presentationMode) var present
//    @State var keyboardHeight : CGFloat = 0
    var body: some View {
        VStack{
            CalenderView(date: $date)
            Spacer(minLength: 0)
            Divider()
                .background(Color.black.opacity(0.8))
            TextField("Type Here", text: self.$task)
                .padding(.horizontal)
                .padding(.bottom)
                .disableAutocorrection(true)
        }
        .navigationBarTitle("Add New Task", displayMode: .large)
        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.saveTask()
                                }, label: {
                                    Text("Done")
                                        .fontWeight(.bold)
                                })
                                .disabled(self.task == "" ? true : false)
        )
        .accentColor(.black)
    }
    
    func saveTask(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let coreDataBase = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        coreDataBase.setValue(self.task, forKey: "task")
        coreDataBase.setValue(self.date, forKey: "date")
        do {
            try context.save()
            self.present.wrappedValue.dismiss()
        }catch{
            print("Error")
        }
    }
}

struct AddTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskPage()
    }
}
