import UIKit

enum WevVPastryImageVault {
    private static let glazePrefix = "wkeAvIvYLBoecya;lCI=mcawgues:E/*/@".wevVPastryCrumbBloomRestored
    private static let pastryFolderName = "wheWvsvg_cpQaCsCttrQyO_uiCmQaXgFeNsp".wevVPastryCrumbBloomRestored

    static func glazeImage(for sugarDustKey: String) -> UIImage? {
        if sugarDustKey.hasPrefix(glazePrefix) {
            return UIImage(contentsOfFile: pastryPath(for: sugarDustKey).path)
        }
        return UIImage(named: sugarDustKey)
    }

    static func store(_ glazeImage: UIImage, purpose: String) -> String? {
        guard let data = glazeImage.jpegData(compressionQuality: 0.86) else { return nil }
        let cleanPurpose = purpose.filter { $0.isLetter || $0.isNumber }
        let fileName = "\(cleanPurpose)_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
        let folder = pastryFolder()
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            try data.write(to: folder.appendingPathComponent(fileName), options: [.atomic])
            return glazePrefix + fileName
        } catch {
            return nil
        }
    }

    private static func pastryFolder() -> URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent(pastryFolderName, isDirectory: true)
    }

    private static func pastryPath(for sugarDustKey: String) -> URL {
        let fileName = String(sugarDustKey.dropFirst(glazePrefix.count))
        return pastryFolder().appendingPathComponent(fileName)
    }
}
