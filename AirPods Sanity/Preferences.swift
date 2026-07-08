//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class Preferences
{
	private static var _Instance: Preferences?
	private let _PreferencesFile: PreferencesFile

	private init()
	{
		self._PreferencesFile = PreferencesLoader.LoadSettings()

		if self._PreferencesFile.InputDeviceNames == nil
		{
			self.InputDeviceNames = self._PreferencesFile.InputDeviceName == nil ? [] : [self._PreferencesFile.InputDeviceName!]
		}
	}
	
	static var Instance: Preferences
	{
		if _Instance == nil
		{
			_Instance = Preferences()
		}

		return _Instance!
	}
	
	public var LaunchOnLogin: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.LaunchOnLogin
			{
				return __UnWrapped
			}
			else
			{
				return false
			}
		}
		set(value)
		{
			self._PreferencesFile.LaunchOnLogin = value
		}
	}
	
	public var ShowInMenuBar: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.ShowInMenuBar
			{
				return __UnWrapped
			}
			else
			{
				return true
			}
		}
		set(value)
		{
			self._PreferencesFile.ShowInMenuBar = value
		}
	}
	
	public var ShowInDock: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.ShowInDock
			{
				return __UnWrapped
			}
			else
			{
				return false
			}
		}
		set(value)
		{
			self._PreferencesFile.ShowInDock = value
		}
	}
	
	public var IsEnabled: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.IsEnabled
			{
				return __UnWrapped
			}
			else
			{
				return true
			}
		}
		set(value)
		{
			self._PreferencesFile.IsEnabled = value
		}
	}
	
	public var InputDeviceName: String?
	{
		get
		{
			return self.InputDeviceNames.first
		}
		set(value)
		{
			self.InputDeviceNames = value == nil ? [] : [value!]
		}
	}

	public var InputDeviceNames: [String]
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.InputDeviceNames
			{
				return self.NormalizeDeviceNames(deviceNames: __UnWrapped)
			}
			else if let __UnWrapped = self._PreferencesFile.InputDeviceName
			{
				return self.NormalizeDeviceNames(deviceNames: [__UnWrapped])
			}
			else
			{
				return []
			}
		}
		set(value)
		{
			let __DeviceNames = self.NormalizeDeviceNames(deviceNames: value)

			self._PreferencesFile.InputDeviceNames = __DeviceNames
			self._PreferencesFile.InputDeviceName = __DeviceNames.first
		}
	}
	
	public var AirPodsDeviceNames: [String]
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.AirPodsDeviceNames
			{
				return __UnWrapped
			}
			else
			{
				return []
			}
		}
		set(value)
		{
			self._PreferencesFile.AirPodsDeviceNames = value
		}
	}
	
	public func WriteSettings()
	{
		PreferencesLoader.WriteSettings(preferences: self._PreferencesFile)
	}

	private func NormalizeDeviceNames(deviceNames: [String]) -> [String]
	{
		var __DeviceNames: [String] = []

		for __DeviceName in deviceNames
		{
			if __DeviceName.isEmpty
			{
				continue
			}

			if !__DeviceNames.contains(__DeviceName)
			{
				__DeviceNames.append(__DeviceName)
			}
		}

		return __DeviceNames
	}
}
