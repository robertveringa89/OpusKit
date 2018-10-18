
// Imports.
import UIKit
import AVFoundation

// Start of class.
public class OpusKit: NSObject
{
    // MARK: - Singleton instance
    
    public static let shared = OpusKit()
    
    // MARK: - Properties
    
    var decoder: OpaquePointer!
    var encoder: OpaquePointer!
    var sampleRate: opus_int32 = 8000
    var numberOfChannels: Int32 = 1
    var packetSize: opus_int32 = 320
    var encodeBlockSize: opus_int32 = 160
    
    // MARK: - Initialization
    
    public func initialize(sampleRate: opus_int32 = 8000, numberOfChannels: Int32 = 1, packetSize: opus_int32 = 320, encodeBlockSize: opus_int32 = 160) {
        
        // Store variables.
        self.sampleRate = sampleRate
        self.numberOfChannels = numberOfChannels
        self.packetSize = packetSize
        self.encodeBlockSize = encodeBlockSize
        
        // Create status var.
        var status = Int32(0)
        
        // Create decoder.
        decoder = opus_decoder_create(sampleRate, numberOfChannels, &status)
        if (status != OPUS_OK) {
            print("OpusKit - Something went wrong while creating opus decoder: \(opusErrorMessage(errorCode: status))")
        }
        
        // Create encoder.
        encoder = opus_encoder_create(sampleRate, numberOfChannels, OPUS_APPLICATION_VOIP, &status)
        if (status != OPUS_OK) {
            print("OpusKit - Something went wrong while creating opus encoder: \(opusErrorMessage(errorCode: status))")
        }
    }
    
    // MARK: - Decode
    
    public func decodeData(_ data: Data) -> Data? {
        var encodedData = [CUnsignedChar](repeating: 0, count: 2048)
        var decodedData = [opus_int16](repeating: 0, count: 2048)
        
        _ = data.withUnsafeBytes {
            memcpy(&encodedData, $0, data.count)
        }
        
        let outputData: NSMutableData = NSMutableData()
        let ret = opus_decode(decoder, encodedData, (opus_int32)(data.count), &decodedData, packetSize, 0)
        if ret > 0 {
            let length: Int = Int(ret) * MemoryLayout<opus_int16>.size
            outputData.append(decodedData, length: length)
        } else {
            print("OpusKit - Something went wrong while decoding data: \(opusErrorMessage(errorCode: ret))")
        }
        
        return outputData as Data
    }
    
    // MARK: - Encode
    
    public func encodeData(_ data: Data) -> Data? {
        
        var encodedData = [CUnsignedChar](repeating: 0, count: 2048)
        var pcmData = [opus_int16](repeating: 0, count: 2048)
        
        _ = data.withUnsafeBytes {
            memcpy(&pcmData, $0, data.count)
        }
        
        let outputData: NSMutableData = NSMutableData()
        let ret = opus_encode(encoder, pcmData, encodeBlockSize, &encodedData, packetSize)
        if ret > 0 {
            let length: Int = Int(ret)
            outputData.append(encodedData, length: length)
        } else {
            print("OpusKit - Something went wrong while encoding data: \(opusErrorMessage(errorCode: ret))")
        }
        
        return outputData as Data
    }
    
    // MARK: - Error handling
    
    private func opusErrorMessage(errorCode: Int32) -> String {
        switch (errorCode) {
        case OPUS_BAD_ARG:
            return "One or more invalid/out of range arguments."
        case OPUS_BUFFER_TOO_SMALL:
            return "The mode struct passed is invalid."
        case OPUS_INTERNAL_ERROR:
            return "The compressed data passed is corrupted."
        case OPUS_INVALID_PACKET:
            return "Invalid/unsupported request number."
        case OPUS_INVALID_STATE:
            return "An encoder or decoder structure is invalid or already freed."
        case OPUS_UNIMPLEMENTED:
            return "Invalid/unsupported request number."
        case OPUS_ALLOC_FAIL:
            return "Memory allocation has failed."
        default:
            return "Unknown error."
        }
    }
}
