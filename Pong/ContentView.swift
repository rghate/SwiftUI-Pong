//
//  ContentView.swift
//  Pong
//
//  Created by Rupali Ghate on 07/10/2020.
//

import SwiftUI


//class BatView: ObservableObject {
//    var foregroundColor: Color
//    var width: CGFloat
//    var height: CGFloat
//
//    var body: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(foregroundColor)
//            .frame(width: width, height: height)
//    }
//
//    init(foregroundColor: Color, width: CGFloat, height: CGFloat) {
//        self.foregroundColor = foregroundColor
//        self.width = width
//        self.height = height
//    }
//}

struct BatView: View {
    var foregroundColor: Color
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundColor(foregroundColor)
            .frame(width: width, height: height)
    }
    
    init(foregroundColor: Color, width: CGFloat, height: CGFloat) {
        self.foregroundColor = foregroundColor
        self.width = width
        self.height = height
    }
}

//class BallView: ObservableObject {
//    @State var foregroundColor: Color
//
//    var body: some View {
//        Circle()
//            .foregroundColor(foregroundColor)
//            .frame(width: 40, height: 40)
//    }
//
//    init(foregroundColor: Color) {
//        self.foregroundColor = foregroundColor
//    }
//}

struct BallView: View {
    var foregroundColor: Color
    var size: CGFloat


    var body: some View {
        Circle()
            .foregroundColor(foregroundColor)
            .frame(width: size, height: size)
    }
    
    init(foregroundColor: Color, size: CGFloat) {
        self.foregroundColor = foregroundColor
        self.size = size
    }
}


struct ContentView: View {
    let batWidth: CGFloat = 150
    let batHeight: CGFloat = 15
    
    //    let statusBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    
    //    let screenBounds = UIScreen.main.bounds
    
    @State private var topBarPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: 70)
    
    @State private var bottomBarPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height - 50)
    
    @State private var ballPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    
    
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
//    var leftBatView = BatView(foregroundColor: .green, width: 150, height: 26)
    
//    var rightBatView = BatView(foregroundColor: .pink, width: 150, height: 26)
    
//    var ballView = BallView(foregroundColor: .red, size: 30)
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                print("value.location.x:", value.location.x)
                print("UIScreen.main.bounds.minX:", UIScreen.main.bounds.minX)
                print("UIScreen.main.bounds.maxX:", UIScreen.main.bounds.maxX)
                print("batWidth + value.location.x:", batWidth + value.location.x)
                print("value.location.x - batWidth / 2:", value.location.x - batWidth / 2)
                print("---------------------------------------")
                guard  (value.location.x - batWidth / 2) > UIScreen.main.bounds.minX, (batWidth / 2 + value.location.x) < UIScreen.main.bounds.maxX else { return }
                
                self.bottomBarPosition.x = value.location.x
            }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                // top bat view
                BatView(foregroundColor: .white, width: batWidth, height: batHeight)
                    .body.position(topBarPosition)
                
                // bottom bat view
                BatView(foregroundColor: .white, width: batWidth, height: batHeight)
                    .body.position(bottomBarPosition)
                    .gesture(drag)
                
                // ball view
                BallView(foregroundColor: .red, size: 30)
                    .position(ballPosition)
                    .onTapGesture(perform: {
                        moveBall(at: 80)
                    })
                    
            }
//            .background(Color.secondary)

        }.background(Color.gray)
        .ignoresSafeArea()
    }
    
    //    func calculateAngle(point1: CGPoint, point2: CGPoint) {
    //
    //    }
    
    func moveBall(at angle1: Double) {
//        let angle: Double = angle
//        let (distance, angle) = getDistanceAndDirection(ballPosition, topBarPosition)
        let (distance, angle) = getDistanceAndDirection(ballPosition, getRandomEndPoint())
        print("Distance: \(distance), Direction: \(angle)")
        let position = getNewPosition(initialPosition: ballPosition, angle: angle, length: distance)
            
        withAnimation(.easeOut(duration: 2)) {
            ballPosition = position
        }
//        withAnimation {
//            ballPosition = position
//        }
    }
//    enum Side: Bool {
//        case TOP
//        case BOTTOM: false
//    }
    
    @State var isAtTheTop: Bool = true
    
    func getRandomEndPoint() -> CGPoint {
        // if currently at top , calculate for bottom bat position
        
        let xPos: CGFloat = CGFloat.random(in: 0..<UIScreen.main.bounds.width - 1)
        let yPos = isAtTheTop == true ? bottomBarPosition.y : topBarPosition.y
        
        isAtTheTop.toggle()
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getDistanceAndDirection(_ pt1: CGPoint, _ pt2: CGPoint) -> (distance: CGFloat, angle: Angle) {
        
//        if !pt2.y.isLessThanOrEqualTo(UIScreen.main.bounds.height/2) {
//            pt2.y = pt2.y * -1
//        }
        let yPos = !pt2.y.isLessThanOrEqualTo(UIScreen.main.bounds.height/2) ? (pt2.y * -1) : pt2.y
//            pt1.y - yPos  // for
        let a = isAtTheTop ?  pt1.y - yPos  :  yPos + pt1.y
        let b = pt2.x - pt1.x // calculate leg b
        
        var alpha = atan2(a, b) // calculate angle
        let s = sin(alpha) // sine of the angle
        let h = (a == 0 ? abs(b) : (a / s)) // calculate hypotenuse, and prevent divide by zero
        
        alpha = alpha < 0 ? alpha + (.pi * 2) : alpha // make sure angles are returned as positive values
        
        return (h, Angle(radians: Double(alpha)))
    }
    
    func getNewPosition(initialPosition: CGPoint, angle: Angle, length: CGFloat) -> CGPoint {
        
        let x = initialPosition.x + length * CGFloat(cos(angle.radians))
        let y = initialPosition.y - length * CGFloat(sin(angle.radians))
        
        let pt2 = CGPoint(x: x, y: y)
        
        return pt2
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
