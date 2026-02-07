import Foundation

struct LocalPersistence {
    static func load<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        let url = documentsDirectory.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    static func save<T: Encodable>(_ value: T, to filename: String) {
        let url = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save \(filename): \(error)")
        }
    }

    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
