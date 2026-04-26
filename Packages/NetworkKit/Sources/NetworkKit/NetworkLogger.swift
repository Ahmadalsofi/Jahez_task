import Foundation

final class NetworkLogger {

    private let isEnabled: Bool

    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }

    func logRequest(_ request: URLRequest) {
        guard isEnabled else { return }
        var output = "\n┌─── REQUEST ────────────────────────────────────────\n"
        output += "│ \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")\n"
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            output += "│ Headers:\n"
            headers.forEach { output += "│   \($0.key): \($0.value)\n" }
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            output += "│ Body: \(bodyString)\n"
        }
        output += "└────────────────────────────────────────────────────"
        print(output)
    }

    func logResponse(_ response: HTTPURLResponse, data: Data) {
        guard isEnabled else { return }
        let status = response.statusCode
        let symbol = (200...299).contains(status) ? "✅" : "❌"
        var output = "\n┌─── RESPONSE \(symbol) ──────────────────────────────────\n"
        output += "│ \(status) \(response.url?.absoluteString ?? "")\n"
        if let json = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let text = String(data: pretty, encoding: .utf8) {
            let indented = text.split(separator: "\n").map { "│ \($0)" }.joined(separator: "\n")
            output += "\(indented)\n"
        } else if let text = String(data: data, encoding: .utf8) {
            output += "│ \(text)\n"
        }
        output += "└────────────────────────────────────────────────────"
        print(output)
    }

    func logError(_ error: Error, url: URL?) {
        guard isEnabled else { return }
        print("\n┌─── ERROR ❌ ───────────────────────────────────────")
        print("│ URL: \(url?.absoluteString ?? "unknown")")
        print("│ \(error.localizedDescription)")
        print("└────────────────────────────────────────────────────")
    }
}
