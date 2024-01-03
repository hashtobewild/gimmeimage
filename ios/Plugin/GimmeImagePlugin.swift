import Foundation
import Capacitor
import Photos

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(GimmeImagePlugin)
public class GimmeImagePlugin: CAPPlugin {
    private let implementation = GimmeImage()

    public class JSDate {
        static func toString(_ date: Date) -> String {
            let formatter = ISO8601DateFormatter()
            return formatter.string(from: date)
        }
    }
    
    func checkAuthorization(allowed: @escaping () -> Void, notAllowed: @escaping () -> Void) {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == PHAuthorizationStatus.authorized {
                allowed()
            } else {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == PHAuthorizationStatus.authorized {
                        allowed()
                    } else {
                        notAllowed()
                    }
                })
            }
        }
    
    func makeLocation(_ asset: PHAsset) -> JSObject {
            var loc = JSObject()
            guard let location = asset.location else {
                return loc
            }

            loc["latitude"] = location.coordinate.latitude
            loc["longitude"] = location.coordinate.longitude
            loc["altitude"] = location.altitude
            loc["heading"] = location.course
            loc["speed"] = location.speed
            return loc
        }
    
    @objc func gimmeMediaItem(_ call: CAPPluginCall) {
            checkAuthorization(allowed: {
                self.gimmeMediaItemWrapped(call)
            }, notAllowed: {
                call.reject("Access to photos not allowed by user")
            })
        }
    
    @objc func gimmeMediaItemWrapped(_ call: CAPPluginCall) {
            let identifier = call.getString("identifier") ?? ""
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", identifier)
            
            let fetchedAssets = PHAsset.fetchAssets(with: fetchOptions)
            
            var a = JSObject()
            if let asset = fetchedAssets.firstObject {
                // Request the image
                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
                    guard let heicImageData = imageData else {
                        return
                    }

                    // Convert HEIC data to UIImage
                    if let heicImage = UIImage(data: heicImageData) {
                        // Convert UIImage to JPEG data
                        if let jpegData = heicImage.jpegData(compressionQuality: 1.0) {
                            var a: [String: Any] = [:]
                            a["identifier"] = asset.localIdentifier
                            a["data"] = jpegData.base64EncodedString(options: .lineLength64Characters)
                            
                            if let creationDate = asset.creationDate {
                                a["creationDate"] = JSDate.toString(creationDate)
                            }
                            
                            a["fullWidth"] = asset.pixelWidth
                            a["fullHeight"] = asset.pixelHeight
                            a["thumbnailWidth"] = asset.pixelWidth
                            a["thumbnailHeight"] = asset.pixelHeight
                            
                            if let fileType = info?["PHImageFileUTIKey"] as? String {
                                a["type"] = fileType
                            } else {
                                a["type"] = "unknown" // Set a default value or handle the case when file type is not available
                            }
                            
                            a["location"] = self.makeLocation(asset)
                            
                            // Send back to JavaScript
                            call.resolve(a)
                        };
                    };
                };
            } else {
                call.reject("Asset not found.")
            }
        }
}
