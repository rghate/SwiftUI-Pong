//
//  ContentView.swift
//  Pong
//
//  Created by Rupali Ghate on 07/10/2020.
//

import SwiftUI


class BatView: ObservableObject {
    var foregroundColor: Color
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(foregroundColor)
            .frame(width: width, height: height)
    }
    
    init(foregroundColor: Color, width: CGFloat, height: CGFloat) {
        self.foregroundColor = foregroundColor
        self.width = width
        self.height = height
    }
}

class BallView: ObservableObject {
    @State var foregroundColor: Color
    
    var body: some View {
        Circle()
            .foregroundColor(foregroundColor)
            .frame(width: 40, height: 40)
    }
    
    init(foregroundColor: Color) {
        self.foregroundColor = foregroundColor
    }
}


struct ContentView: View {
    let batWidth: CGFloat = 40
    let batHeight: CGFloat = 200
    
    //    let statusBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    
    //    let screenBounds = UIScreen.main.bounds
    
    @State private var leftPosition: CGPoint = CGPoint(x: 0 + 20, y: UIScreen.main.bounds.midY)
    
    @State private var rightPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.minX + UIScreen.main.bounds.width - 20, y: UIScreen.main.bounds.midY)
    
    @State private var ballPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    
    
    @ObservedObject var leftBatView = BatView(foregroundColor: .green, width: 40, height: 200)
    
    @ObservedObject var rightBatView = BatView(foregroundColor: .pink, width: 40, height: 200)
    
    @ObservedObject var ballView = BallView(foregroundColor: .red)
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                guard  value.location.y - 100 > UIScreen.main.bounds.minY, value.location.y + 100 < UIScreen.main.bounds.minY + UIScreen.main.bounds.height else { return }
                
                self.rightPosition.y = value.location.y
            }
    }
    
    var body: some View {
        
        ZStack {
            
            // left rectangle
            leftBatView.body.position(leftPosition)
            
            // right rectangle
            rightBatView.body.position(rightPosition)
                .gesture(drag)
            
            ballView.body
                .position(ballPosition)
                .onTapGesture(perform: {
                    moveBall(at: 45)
                })
        }
    }
    
    func calculateAngle(point1: CGPoint, point2: CGPoint) {
        
    }
    
    func moveBall(at angle: CGFloat) {
        ballPosition = CGPoint(x: 100, y: 100)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
