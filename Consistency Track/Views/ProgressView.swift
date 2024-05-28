import SwiftUI

struct ProgressCircleView: View {
    var progress: Double
    var total: Double
    
    private var percentage: Double {
        return (progress / total) * 100
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress / total, 1.0)))
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.5)]), center: .center),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: 150, height: 150)
                
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 20)
                    .frame(width: 150, height: 150)
                
                VStack {
                    Text(String(format: "%.0f%%", min(percentage, 100.0)))
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    ProgressCircleView(progress: 5, total: 10)
}
