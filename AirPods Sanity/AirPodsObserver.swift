//
//  ObservableSCA.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//

import Foundation
import SimplyCoreAudio

class AirPodsObserver: ObservableObject
{
	private let _Preferences: Preferences
	private let _Simply: SimplyCoreAudio
	private let _NotificationCenter: NotificationCenter

	private var _Observers: [NSObjectProtocol]

	private var _DefaultInputDeviceName: String?

	// When a device last connected or disconnected. Launch counts as one.
	private var _LastDeviceListChange: Date

	init()
	{
		self._Preferences = Preferences.Instance
		self._Simply = SimplyCoreAudio()
		self._NotificationCenter = NotificationCenter.default
		self._Observers = []
		self._LastDeviceListChange = Date()

		self.UpdateDefaultInputDevice()
		self.AddObservers()
	}

	deinit
	{
		self.RemoveObservers()
	}
}

private extension AirPodsObserver
{
	func UpdateDefaultInputDevice()
	{
		guard let __DefaultInputDevice = self._Simply.defaultInputDevice else { return }
		guard let _ = self._Preferences.AirPodsDeviceNames.filter({ $0 == __DefaultInputDevice.name }).first else
		{
			self._DefaultInputDeviceName = __DefaultInputDevice.name
			return
		}

		if !self._Preferences.IsEnabled
		{
			return
		}

		// No device came or went just now, so the user picked the AirPods mic. Leave it.
		if Date().timeIntervalSince(self._LastDeviceListChange) > 10
		{
			return
		}

		guard let __InputDevice = self.GetPreferredInputDevice() else { return }

		if __DefaultInputDevice.id != __InputDevice.id
		{
			NSLog("AirPods Sanity: \(__DefaultInputDevice.name) took over the input, switching to \(__InputDevice.name)")
			self.RemoveObservers()
			__InputDevice.isDefaultInputDevice = true
			self.AddObservers()
		}

		let __Seconds = 10.0

		DispatchQueue.main.asyncAfter(deadline: .now() + __Seconds)
		{
			guard let __DefaultOutputDevice = self._Simply.defaultOutputDevice else { return }
			guard let __SampleRates = __DefaultOutputDevice.nominalSampleRates?.sorted(by: { $0 > $1 }) else { return }

			self.RemoveObservers()
			__DefaultOutputDevice.setNominalSampleRate(__SampleRates[0])
			self.AddObservers()
		}
	}

	func GetPreferredInputDevice() -> AudioDevice?
	{
		let __InputDevices = self._Simply.allInputDevices

		for __InputDeviceName in self._Preferences.InputDeviceNames
		{
			if let __InputDevice = __InputDevices.filter({ $0.name == __InputDeviceName }).first
			{
				return __InputDevice
			}
		}

		if let __DefaultInputDeviceName = self._DefaultInputDeviceName
		{
			return __InputDevices.filter({ $0.name == __DefaultInputDeviceName }).first
		}

		return nil
	}

	func AddObservers()
	{
		self._Observers.append(contentsOf:[
			self._NotificationCenter.addObserver(forName: .deviceListChanged, object: nil, queue: .main) { (notification) in
				// Also posted when no device came or went, e.g. on picking the AirPods mic.
				let __Added = notification.userInfo?["addedDevices"] as? [AudioDevice] ?? []
				let __Removed = notification.userInfo?["removedDevices"] as? [AudioDevice] ?? []

				if !__Added.isEmpty || !__Removed.isEmpty
				{
					self._LastDeviceListChange = Date()
				}

				// A mic from the priority list was plugged in and now ranks first. macOS may not pick it on its own.
				if self._Preferences.IsEnabled,
				   let __Preferred = self.GetPreferredInputDevice(),
				   __Added.contains(where: { $0.id == __Preferred.id }),
				   self._Simply.defaultInputDevice?.id != __Preferred.id
				{
					NSLog("AirPods Sanity: \(__Preferred.name) plugged in, switching input to it")
					self.RemoveObservers()
					__Preferred.isDefaultInputDevice = true
					self.AddObservers()
				}

				self.UpdateDefaultInputDevice()
			},

			self._NotificationCenter.addObserver(forName: .defaultInputDeviceChanged, object: nil, queue: .main) { (_) in
				self.UpdateDefaultInputDevice()
			},
		])
	}

	func RemoveObservers()
	{
		for __Observer in self._Observers
		{
			self._NotificationCenter.removeObserver(__Observer)
		}

		self._Observers.removeAll()
	}
}
