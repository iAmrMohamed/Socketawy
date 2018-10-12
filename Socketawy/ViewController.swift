//
//  ViewController.swift
//  Socketawy
//
//  Created by Amr Mohamed on 7/17/18.
//  Copyright © 2018 Amr Mohamed. All rights reserved.
//

import Cocoa
import Starscream

class ViewController: NSViewController {
    
    @IBOutlet var textField: NSTextField! {
        didSet {
            self.textField.delegate = self
        }
    }
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var scrollView: NSScrollView!
    
    @IBOutlet var connectButton: NSButton!
    @IBOutlet var disconnectButton: NSButton!
    @IBOutlet var clearButton: NSButton!
    
    var socket: WebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.string = "\n"
    }
    
    @IBAction func connectAction(_ sender: NSButton) {
        if self.textField.stringValue.isEmpty {
            self.textField.shake()
            return
        }
        if let url = URL.init(string: self.textField.stringValue) {
            self.connectToSocket(url: url)
        } else {
            self.textField.shake()
        }
    }
    
    @IBAction func disconnectAction(_ sender: NSButton) {
        self.connectButton.title = "Connect"
        self.textView.string += "Disconnected" + "\n\n"
        self.socket?.disconnect()
        self.socket?.delegate = nil
        self.socket = nil
    }
    
    @IBAction func clearAction(_ sender: NSButton) {
        self.textView.string = "\n"
    }
    
    func connectToSocket(url: URL) {
        guard self.socket == nil else {
            self.disconnectButton.shake()
            return
        }
        self.connectButton.title = "Connecting"
        self.textView.window?.makeFirstResponder(nil)
        self.socket = WebSocket.init(url: url)
        self.socket?.delegate = self
        self.socket?.connect()
    }
}

extension ViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        self.connectButton.title = "Connected"
        self.textView.string += "Connected" + "\n\n"
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error?.localizedDescription ?? "No Error")
        self.textView.string += "Disconnected: \(error?.localizedDescription ?? "No Reason")" + "\n\n"
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        self.textView.string += text + "\n\n"
        self.textView.scrollToEndOfDocument(nil)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(#function)
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            if !self.textField.stringValue.isEmpty, let url = URL.init(string: self.textField.stringValue) {
                self.connectToSocket(url: url)
            } else {
                self.textField.shake()
            }
            return true
        }
        return false
    }
}
