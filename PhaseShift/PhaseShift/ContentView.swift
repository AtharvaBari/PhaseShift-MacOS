import SwiftUI

struct ContentView: View {
    @AppStorage("viewMode") private var viewMode: String = "age"
    @AppStorage("offsetX") private var offsetX: Double = 0.0
    @AppStorage("offsetY") private var offsetY: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            Group {
                if viewMode == "year" {
                    YearProgressView()
                } else {
                    AgeView()
                }
            }
            .offset(x: offsetX, y: offsetY)
        }
    }
}
