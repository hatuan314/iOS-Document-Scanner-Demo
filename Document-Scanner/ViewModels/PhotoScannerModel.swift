//
//  PhotoScannerModel.swift
//  Document-Scanner
//
//  Created by Tuan Hoang on 28/10/24.
//

import UIKit

class PhotoScannerModel: NSObject, ImageScannerControllerDelegate {
    var image: UIImage?
    
    func detectDocumentEdges(image: UIImage) {
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        if let windowScene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(scannerViewController, animated: true, completion: nil)
            }
        }
    }
    
    func imageScannerController(
        _ scanner: ImageScannerController,
        didFinishScanningWithResults results: ImageScannerResults) {
        // Xử lý ảnh quét đã cắt (croppedScan) hoặc ảnh gốc (originalImage)
        image = results.croppedScan.image
        // Chuyển ảnh thành dữ liệu PNG
//        if let imageData = scannedImage.pngData() {
//            let imageBase64 = imageData.base64EncodedString()
//            // Trả ảnh đã quét về Flutter dưới dạng chuỗi base64
//            result?(imageBase64)
//        } else {
//            result?(FlutterError(code: "PROCESS_FAILED", message: "Failed to process scanned image", details: nil))
//        }
        
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
//        result?(FlutterError(code: "SCAN_CANCELLED", message: "User cancelled the scan", details: nil))
        print("[SCAN_CANCELLED] -----> User")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: any Error) {
        scanner.dismiss(animated: true, completion: nil)
//        result?(FlutterError(code: "SCAN_ERROR", message: "An error occurred during scanning", details: error.localizedDescription))
        print("[SCAN_ERROR] -----> An error occurred during scanning - \(error.localizedDescription)")
    }
    
    
}
