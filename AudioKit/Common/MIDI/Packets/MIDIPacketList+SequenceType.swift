//
//  MIDIPacketList+SequenceType.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//
import CoreMIDI

extension MIDIPacketList: Sequence {
    public typealias Element = MIDIPacket

    public var count: UInt32 {
        return self.numPackets
    }

    public func makeIterator() -> AnyIterator<Element> {

        withUnsafePointer(to: packet) { ptr in
            var p = ptr
            var idx: UInt32 = 0

            return AnyIterator {
                guard idx < self.numPackets else {
                    return nil
                }

                idx += 1
                let packet = extractPacket(p)
                p = UnsafePointer(MIDIPacketNext(p))
                return packet
            }
        }
    }
    
    public func extractPacketData(_ ptr: UnsafePointer<MIDIPacket>) -> [UInt8] {

        let raw = UnsafeRawPointer(ptr)
        let dataPtr = raw.advanced(by: MemoryLayout.offset(of: \MIDIPacket.data)!)

        let length = Int(raw.load(fromByteOffset: MemoryLayout.offset(of: \MIDIPacket.length)!,
                                           as: UInt16.self))

        var array = [UInt8](repeating: 0, count: length)
        memcpy(&array, dataPtr, length)

        return array
    }
    
    public func extractPacket(_ ptr: UnsafePointer<MIDIPacket>) -> MIDIPacket? {

        var packet = MIDIPacket()
        let raw = UnsafeRawPointer(ptr)

        let length = raw.load(fromByteOffset: MemoryLayout.offset(of: \MIDIPacket.length)!,
                                       as: UInt16.self)

        // We can't represent a longer packet as a MIDIPacket value.
        if length > 256 {
            return nil
        }

        packet.length = length
        packet.timeStamp = raw.load(fromByteOffset: MemoryLayout.offset(of: \MIDIPacket.timeStamp)!,
                                             as: MIDITimeStamp.self)

        let dataPtr = raw.advanced(by: MemoryLayout.offset(of: \MIDIPacket.data)!)
        _ = withUnsafeMutableBytes(of: &packet.data) { ptr in
            memcpy(ptr.baseAddress!, dataPtr, Int(length))
        }

        return packet
    }
}
