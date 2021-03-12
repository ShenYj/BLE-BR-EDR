//
//  CBManagerState+Ex.swift
//  BREDR
//
//  Created by ShenYj on 2021/03/12.
//
//  Copyright (c) 2021 ShenYj <shenyanjie123@foxmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import CoreBluetooth

extension CBManagerState: CustomDebugStringConvertible {
    
    /*!
     *  @enum CBManagerState
     *
     *  @discussion Represents the current state of a CBManager.
     *
     *  @constant CBManagerStateUnknown       State unknown, update imminent.
     *  @constant CBManagerStateResetting     The connection with the system service was momentarily lost, update imminent.
     *  @constant CBManagerStateUnsupported   The platform doesn't support the Bluetooth Low Energy Central/Client role.
     *  @constant CBManagerStateUnauthorized  The application is not authorized to use the Bluetooth Low Energy role.
     *  @constant CBManagerStatePoweredOff    Bluetooth is currently powered off.
     *  @constant CBManagerStatePoweredOn     Bluetooth is currently powered on and available to use.
     *
     *    @seealso  authorization
     */
    
    /**
     *  @property state
     *
     *  @discussion The current state of the manager, initially set to <code>CBManagerStateUnknown</code>.
     *                Updates are provided by required delegate method {@link managerDidUpdateState:}.
     *
     */
    public var debugDescription: String {
        switch self {
        case .resetting:        return "resetting"
        case .unsupported:      return "unsupported"
        case .unauthorized:     return "unauthorized"
        case .poweredOff:       return "poweredOff"
        case .poweredOn:        return "poweredOn"
        case .unknown:          fallthrough
        @unknown default:       return "unknown"
            
        }
    }

}
