import SwiftUI

struct WelcomeView: View {
    @Binding var isWelcomeScreenShown: Bool
    
    var body: some View {
        ZStack {
            // Fondo de imagen
            Image("runn")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Contenido de bienvenida
            VStack(spacing: 30) {
                Spacer()
                
                Text("Welcome to\nConsistency Tracker")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                
                Text("This app helps you keep track of your consistency in various activities. Set goals and monitor your progress.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                
                VStack(alignment: .leading, spacing: 10) {
                                   Text("Why Consistency Matters:")
                                       .font(.system(size: 22, weight: .bold))
                                       .foregroundColor(.white)
                                       .shadow(color: .black, radius: 2, x: 1, y: 1)
                                   
                                   Text("• Build good habits")
                                       .font(.system(size: 18, weight: .medium))
                                       .foregroundColor(.white)
                                       .shadow(color: .black, radius: 2, x: 1, y: 1)
                                   
                                   Text("• Improve self-discipline and willpower")
                                       .font(.system(size: 18, weight: .medium))
                                       .foregroundColor(.white)
                                       .shadow(color: .black, radius: 2, x: 1, y: 1)
                                   
                                   Text("• Overcome challenges and stay motivated")
                                       .font(.system(size: 18, weight: .medium))
                                       .foregroundColor(.white)
                                       .shadow(color: .black, radius: 2, x: 1, y: 1)
                                   
                                   Text("• Achieve anything with perseverance")
                                       .font(.system(size: 18, weight: .medium))
                                       .foregroundColor(.white)
                                       .shadow(color: .black, radius: 2, x: 1, y: 1)
                               }
                               .padding(.horizontal, 30)
                
                Spacer()
                
                Button(action: {
                    isWelcomeScreenShown = false
                }) {
                    Text("Let's Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    WelcomeView(isWelcomeScreenShown: .constant(true))
}
