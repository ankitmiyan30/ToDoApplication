//
//  HomeCalenderView.swift
//  ToDoApp
//
//  Created by Anthony Ankit on 20/10/20.
//
import SwiftUI

struct HomeCalenderView : View {
    @State var date = Date()
    @State var data : DateType!
    var body: some View{
        VStack{
            if self.data != nil{
                ZStack{
                    VStack(spacing: 15){
                        ZStack {
                            HStack{
                                Spacer()
                                Text(data.Month)
                                    .font(.title)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                        .background(Color.red)
                        Text(self.data.Date)
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                        Text(self.data.Day)
                            .font(.title)
                        Divider()
                        ZStack{
                            Text(data.Year)
                                .font(.title)
                        }
                    }
                    .padding(.bottom,12)
                }
                .frame(width: UIScreen.main.bounds.width / 1.5)
                .background(Color.white)
                .cornerRadius(15)
            }
        }
        .onAppear {
            // updating date when ever it appears...
            self.date = Date()
            self.UpdateDate()
        }
    }
    
    func UpdateDate(){
        
        let current = Calendar.current
        
        let date = current.component(.day, from: self.date)
        let monthNO = current.component(.month, from: self.date)
        let month = current.monthSymbols[monthNO - 1]
        let year = current.component(.year, from: self.date)
        let weekno = current.component(.weekday, from: self.date)
        let day = current.weekdaySymbols[weekno - 1]
        
        self.data = DateType(Day: day, Date: "\(date)", Year: "\(year)", Month: month)
    }
}


struct HomeCalender_Previews: PreviewProvider {
    static var previews: some View {
        HomeCalenderView()
    }
}
