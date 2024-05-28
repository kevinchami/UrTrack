import SwiftUI
import ConfettiSwiftUI

struct ConfettiView: View {
    @Binding var counter: Int
    
    var body: some View {
        ConfettiCannon(counter: $counter, num: 50, confettis: [.text("🎉"), .text("🎊"), .shape(.circle), .shape(.triangle)], colors: [.red, .green, .blue, .orange], confettiSize: 20, repetitions: 3, repetitionInterval: 0.5)
    }
}
