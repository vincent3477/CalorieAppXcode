//
//  CameraManager.swift
//  DailyCalories
//
//  Created by Vincent Siu on 12/16/24.
//



import AVFoundation
import UIKit
import SwiftUI
import CoreImage
 
class CameraManager: NSObject, capturePhotoDelegate{
    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private let photoOutput = AVCapturePhotoOutput()
    
    
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var addToPreviewStream: ((CGImage)->Void)?
    
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream{continuation in
            addToPreviewStream = {cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    //Ask for camera access, and obtain authorization status.
    private var isAuthorized: Bool{
        get async{
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = authStatus == .authorized
            
            if authStatus == .notDetermined{
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
        
    }
    
    override init(){
        super.init()
        Task{
            await configureSession()
            await startSession()
        }
    }

    
    private func configureSession() async {
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
       
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput) //This is for video preview.
        captureSession.addOutput(photoOutput)
        
        if let connection = videoOutput.connection(with: .video){
            configureConnection(connection)
        }
                
    }
    
    
    
    private func startSession() async{
        guard await isAuthorized else{
            return
        }
        captureSession.startRunning()
        NotificationCenter.default.addObserver(self, selector: #selector(handleButtonPressed), name: .buttonPressedNotification, object: nil)
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc func handleButtonPressed(){
        capturePhoto()
    }
    
    private func configureConnection(_ connection: AVCaptureConnection){
        if connection.isVideoRotationAngleSupported(90){
            connection.videoRotationAngle = 90
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else {
            print("Can't translate to CGImage")
            return
        }
        addToPreviewStream?(currentFrame)
    }
    
}

extension CMSampleBuffer{
    var cgImage: CGImage?{
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        guard let imagePixelBuffer = pixelBuffer else {
            return nil
        }
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
        
    }
}

extension CIImage{
    var cgImage: CGImage? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent)else{
            return nil
        }
        return cgImage
    }
}



extension CameraManager: AVCapturePhotoCaptureDelegate{
    func saveImage(_ imageData: Data ){
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("photo.jpg")
            
        do{
            try imageData.write(to: fileURL)
            print("Photo saved to file system at \(fileURL.path)")
            NotificationCenter.default.post(name: .photoSavedNotification, object: nil)

        }catch{
            print("Unable to save photo")
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        if let error = error{
            print("Error capturing photo: \(error)")
            return
        }
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else{
            print("Failed to process photo.")
            return
        }
        saveImage(imageData)
    }
    
}

extension Notification.Name{
    static let photoSavedNotification = Notification.Name("photoSavedNotification")
}
