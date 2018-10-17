
// Imports.
import UIKit
import AVFoundation

// Start of class.
public class OpusController: NSObject
{
    // MARK: - Singleton instance
    
    public static let shared = OpusController()
    
    // MARK: - Defines
    
    let sampleRate: opus_int32 = 8000
    let numberOfChannels: Int32 = 1
    let packetSize: opus_int32 = 320
    let encodeBlockSize: opus_int32 = 160
    
    // MARK: - Properties
    
    var decoder: OpaquePointer!
    var encoder: OpaquePointer!
    
    // MARK: - Initialization
    
    public func initialize()
    {
        var status = Int32(0)
        decoder = opus_decoder_create(sampleRate, numberOfChannels, &status)
        encoder = opus_encoder_create(sampleRate, numberOfChannels, OPUS_APPLICATION_VOIP, &status)
    }
    
    // MARK: - Decode
    
    public func decodeTrafficData(_ data: Data) -> Data? {
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
            print("WTFFFFFF")
        }
        
        return outputData as Data
    }
    
    // MARK: - Encode
    
    public func encodeTrafficData(_ data: Data) -> Data? {
        
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
            print("WTFFFFFF")
        }
        
        return outputData as Data
    }
}
