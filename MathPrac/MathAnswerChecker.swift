import Foundation

class MathAnswerChecker {
    static func compare(_ userAnswer: String, correctAnswer: String) -> Bool {
        let normalizedUser = normalize(userAnswer)
        let normalizedCorrect = normalize(correctAnswer)
        
        if normalizedUser == normalizedCorrect {
            return true
        }
        
        if let userNum = parseNumber(normalizedUser),
           let correctNum = parseNumber(normalizedCorrect) {
            return abs(userNum - correctNum) < 0.0001
        }
        
        let correctAlternatives = correctAnswer
            .components(separatedBy: " or ")
            .map { normalize($0) }
        
        for alt in correctAlternatives {
            if normalizedUser == alt {
                return true
            }
            if let userNum = parseNumber(normalizedUser),
               let altNum = parseNumber(alt) {
                if abs(userNum - altNum) < 0.0001 {
                    return true
                }
            }
        }
        
        return false
    }
    
    private static func normalize(_ str: String) -> String {
        var result = str.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
        
        result = result.replacingOccurrences(of: "√", with: "sqrt")
        result = result.replacingOccurrences(of: "×", with: "*")
        result = result.replacingOccurrences(of: "÷", with: "/")
        result = result.replacingOccurrences(of: "−", with: "-")
        
        return result
    }
    
    private static func parseNumber(_ str: String) -> Double? {
        if let num = Double(str) {
            return num
        }
        
        let fractionPattern = #"^(-?\d+)/(\d+)$"#
        if let regex = try? NSRegularExpression(pattern: fractionPattern),
           let match = regex.firstMatch(in: str, range: NSRange(str.startIndex..., in: str)) {
            if let numRange = Range(match.range(at: 1), in: str),
               let denRange = Range(match.range(at: 2), in: str),
               let numerator = Double(str[numRange]),
               let denominator = Double(str[denRange]),
               denominator != 0 {
                return numerator / denominator
            }
        }
        
        return nil
    }
}
