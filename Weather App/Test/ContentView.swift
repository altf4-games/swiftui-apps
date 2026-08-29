//
//  ContentView.swift
//  Test
//
//  Created by Pradyum Mistry on 22/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isNight = false
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack(spacing: 8) {
                Text("Cuppertino, CA").font(.system(size: 32, weight: .medium, design: .default)).foregroundColor(Color.white).padding(10)
                
                VStack {
                    Image(systemName: isNight ? "moon.stars.fill" : "cloud.sun.fill").renderingMode(.original).resizable().aspectRatio(contentMode: .fit).frame(width: 180, height: 180)
                    Text("76°").font(.system(size: 70, weight: .medium, design: .default)).foregroundColor(Color.white)
                }.padding(20)
                
                HStack(spacing: 24) {
                    WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 74)
                    WeatherDayView(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 70)
                    WeatherDayView(dayOfWeek: "THU", imageName: "wind.snow", temperature: 66)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "sunset.fill", temperature: 60)
                    WeatherDayView(dayOfWeek: "SAT", imageName: "wind.snow", temperature: 55)
                }
                
                Spacer()
                
                Button {
                    isNight = !isNight
                } label: {
                    ButtonView(buttonText: "Change Day Time")
                }
                
                Spacer()
                
            }
        }
    }
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
           Text(dayOfWeek).font(.system(size: 20, weight: .medium, design: .default)).foregroundColor(.white)
           Image(systemName: imageName).renderingMode(.original).resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50)
           Text("\(temperature)°").font(.system(size: 30, weight: .medium, design: .default)).foregroundColor(Color.white)
       }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight : Bool
    
    var body: some View {
        LinearGradient(colors: [isNight ? .black : .blue, isNight ? .gray : .white], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges: .all)
    }
}

struct ButtonView: View {
    var buttonText: String
    
    var body: some View {
        Text(buttonText).frame(width: 250, height: 50).background(Color.white).font(.system(size: 20, weight: .bold, design: .default)).cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
