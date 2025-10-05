import Foundation
import SwiftUI

@MainActor
class GeminiService: ObservableObject {
    @Published var responseText: String = "Salut! Sunt Mr. Green 🌱"
    @Published var isLoading: Bool = false
    
    private let apiKey = "API" // API gemini

    func ask(_ question: String, temperature: Double? = nil, airQuality: String? = nil) async {
        guard let url = URL(string:
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateText?key=\(apiKey)"
        ) else {
            responseText = "!!! URL invalid"
            return
        }

        let lower = question.lowercased()
        let ecoKeywords = ["aer", "poluare", "temperatura", "eco", "mediu", "calitatea aerului"]
        let isEcoQuestion = ecoKeywords.contains { lower.contains($0) }

        let prompt: String
        if isEcoQuestion, let temp = temperature, let air = airQuality {
            prompt = "Întrebare: \(question)\nDate mediu: Temperatura: \(temp)°C, Calitatea aerului: \(air)\nRăspunde clar, concis, fără saluturi sau mesaje generale."
        } else {
            prompt = "Întrebare: \(question)\nRăspunde clar și concis, fără saluturi sau mesaje generale."
        }

        let payload: [String: Any] = [
            "prompt": prompt,
            "temperature": 0.7,
            "candidate_count": 1,
            "max_output_tokens": 500
        ]

        isLoading = true
        responseText = "💭 Hmmm..."

        do {
            let data = try JSONSerialization.data(withJSONObject: payload)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data

            let (responseData, _) = try await URLSession.shared.data(for: request)

            if let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let text = candidates.first?["output"] as? String {
                responseText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                let errorString = String(data: responseData, encoding: .utf8) ?? "Ha?"
                responseText = "kaput: \(errorString)"
            }
        } catch {
            responseText = "kaput retea: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
