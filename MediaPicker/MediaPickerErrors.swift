
import Foundation

public enum MediaPickerErrors: Error {
    case imageURL([URL], errors: [Error])
    case missingFileRepresentation
}
