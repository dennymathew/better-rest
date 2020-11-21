//
//  ContentView.swift
//  BetterRest
//
//  Created by Denny Mathew on 21/11/20.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    private static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    private static func nickName(_ wakeUpTime: Date) -> String {
        let hour = Calendar.current.dateComponents([.hour], from: wakeUpTime).hour
        switch hour {
        case 3, 4:
            return "Early bird"
        case 5, 6:
            return "Mr. Productive"
        case 7, 8, 9:
            return "Night owl"
        case 10, 11, 12, 13:
            return "Creator"
        case 14, 15, 16, 17, 18, 19, 20, 21, 22, 0, 1, 2:
            return "Night shifter"
        default:
            return ""
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker(ContentView.nickName(wakeUpTime), selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(value: $coffeeAmount, in: 0...20) {
                        let suffix = coffeeAmount == 1 ? "cup" : "cups"
                        Text("\(coffeeAmount) " + suffix)
                    }
                }
                let bedTime = self.bedTime
                Text(bedTime.0)
                Text(bedTime.1)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color.orange)
                Spacer()
            }
            .navigationBarTitle("Better Sleep")
            .foregroundColor(.orange)
        }
    }
    var bedTime: (String, String) {
        let sleepCalculator = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try sleepCalculator.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUpTime - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return ("Your ideal bedtime", formatter.string(from: sleepTime))
        } catch {
            return ("Sorry, we encountered an error while calculating your bedtime.", "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
