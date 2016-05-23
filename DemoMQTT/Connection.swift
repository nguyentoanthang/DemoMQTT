//
//  Connection.swift
//  DemoMQTT
//
//  Created by mac on 4/25/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import CocoaMQTT

class Connection {
    
    var mqtt: CocoaMQTT?
    
    static let instance = Connection()
    
    func connect() {
        mqtt!.connect()
    }
    
    private init() {
        let clientIdPid = "CocoaMQTT-" + String(NSProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientId: clientIdPid, host: "iot.eclipse.org", port: 1883)
        //mqtts
        //let mqtt = CocoaMQTT(clientId: clientIdPid, host: "localhost", port: 8883)
        //mqtt.secureMQTT = true
        if let mqtt = mqtt {
            mqtt.username = "test"
            mqtt.password = "public"
            mqtt.keepAlive = 90
            mqtt.delegate = self
        }
    }
}

extension Connection: CocoaMQTTDelegate {
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect Ack")
        if ack == .ACCEPT {
            mqtt.subscribe("thang")
            mqtt.ping()
        }
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string!) with id \(id) in topic \(message.topic)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(info: String) {
        print("Delegate: \(info)")
    }

}
