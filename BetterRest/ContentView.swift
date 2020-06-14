//
//  ContentView.swift
//  BetterRest
//
//  Created by Paul Krznaric on 2020-06-11.
//  Copyright © 2020 Krznarnetic. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")                     .font(.headline))
                {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")
                .font(.headline)){
                    
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(){
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach( 0..<21) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                }
                    
                Section(header: Text("Recommended Bed Time:") .font(.headline)
                    .CenterText()){
                    Text("\(calculatedBedTime)")
                        .font(.largeTitle)
                        .foregroundColor(Color(UIColor.systemGreen))
                        .CenterText()
                }
                    
                    
                .navigationBarTitle("BetterRest")
                
            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var calculatedBedTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
        } catch{
            return "There was an error, please try again"
        }
    }
}

struct Center: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

extension View {
    func CenterText() -> some View {
        self.modifier(Center())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
