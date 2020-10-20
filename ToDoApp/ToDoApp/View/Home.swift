//
//  Home.swift
//  ToDoApp
//
//  Created by Anthony Ankit on 20/10/20.
//

import SwiftUI
import CoreData
struct Home: View {
    @State var todayTask : [TaskModel] = []
    @State var editMode = EditMode.inactive
    var body: some View {
        NavigationView{
            VStack{
                HomeCalenderView()
                    .padding(.vertical, 20)
                VStack {
                    HStack{
                        Text("Tasks")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink(destination: AddTaskPage()) {
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.leading)
                    Divider()
                        .background(Color.black.opacity(0.8))
                }
                
                GeometryReader{ _ in
                    if !self.todayTask.isEmpty {
                        ScrollView(.vertical, showsIndicators: false){
                            VStack {
                                ForEach(0..<self.todayTask.count, id: \.self){ i in
                                    HStack {
                                        Button(action: {
                                            self.deleteParticularTask(index: i)
                                        }) {
                                            Image(systemName: "checkmark.circle")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.green)
                                                .padding(.trailing,10)
                                        }
                                        Text(self.todayTask[i].task)
                                        Spacer()
                                        Text(self.todayTask[i].date)
                                            .padding(.horizontal)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                }
                                .onDelete(perform: self.deleteNumber)
                            }
                        }
                    }
                    
                }
                
            }
            .environment(\.editMode, self.$editMode)
            .navigationBarTitle("ToDo", displayMode: .large)
            .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
            .onAppear(){
                self.deleteOldTask()
                self.fetchList()
            }
        }
    }
    
    func fetchList(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            self.todayTask.removeAll()
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let task = obj.value(forKey: "task") as! String
                let date = obj.value(forKey: "date") as! Date
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-YYYY"
                if formatter.string(from: date) >= formatter.string(from: Date()){
                    self.todayTask.append(TaskModel(task: task, date: formatter.string(from: date)))
                }
            }
        }catch{
            print("")
        }
    }
    
    func deleteOldTask(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let date = obj.value(forKey: "date") as! Date
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-YYYY"
                if formatter.string(from: date) < formatter.string(from: Date()){
                    context.delete(obj)
                    try context.save()
                }
            }
        }catch{
            print("")
        }
    }
    
    func deleteNumber(at offsets: IndexSet) {
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let currentObject = obj.value(forKey: "task") as! String
                if self.todayTask[offsets[offsets.startIndex]].task == currentObject {
                    context.delete(obj)
                    try context.save()
                    self.todayTask.remove(atOffsets: offsets)
                    return
                    
                }
            }
        }catch{
            print("")
        }
    }
    func deleteParticularTask(index: Int){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let currentObject = obj.value(forKey: "task") as! String
                if self.todayTask[index].task == currentObject {
                    context.delete(obj)
                    try context.save()
                    self.todayTask.remove(at: index)
                    return
                    
                }
            }
        }catch{
            print("")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
