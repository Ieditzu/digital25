import SwiftUI

struct MrGreenAIView: View {
    @StateObject private var gemini = GeminiService()
    @State private var userInput: String = ""
    @FocusState private var focused: Bool
    @State private var showInfo = false

    @State private var currentTemp: Double = 28.0
    @State private var currentAir: String = "Moderată"

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🤖 Mr. Green AI")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
                
                Spacer()
                
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .alert("Despre Mr. Green AI", isPresented: $showInfo) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("""
                    Mr. Green AI 🌱 este asistentul tău ecologic.
                    - Analizează calitatea aerului și temperatura.
                    - Oferă sfaturi personalizate pentru un mediu mai sănătos.
                    - Răspunde la întrebări legate de protecția mediului.
                    - Răspunde direct, fără mesaje generice sau inventate.
                    """)
                }
            }
            .padding(.horizontal)

            ScrollView {
                Text(gemini.responseText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .frame(height: 180)

            HStack {
                TextField("Ex: Cum pot reduce poluarea în casă?", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focused)

                Button {
                    focused = false
                    Task {
                        await gemini.ask(userInput, temperature: currentTemp, airQuality: currentAir)
                    }
                    userInput = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .disabled(userInput.isEmpty)
            }
            .padding(.horizontal)

            if gemini.isLoading {
                ProgressView("Mr. Green AI gândește...")
                    .padding()
            }

            Spacer()
        }
        .padding(.top)
    }
}
