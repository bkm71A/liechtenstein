// This is the presentation model for UserPreferencesView
package com.incheck.model
{
	import com.incheck.common.UserPreference;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class UserPreferencesModel extends EventDispatcher
	{				
		private var _availableUserPreferences:ArrayCollection;
		private var _userPreferences:ArrayCollection;
		
		private var _accelerationUnits:ArrayCollection;
		private var _accelerationRefLevel:String;
		private var _velocityRefLevel:String;
		private var _velocityUnits:ArrayCollection;
		private var _displacementUnits:ArrayCollection;
		private var _frequencyUnits:ArrayCollection;
		private var _timeUnits:ArrayCollection;
		private var _temperatureUnits:ArrayCollection;
		private var _pressureUnits:ArrayCollection;
		private var _vibrationType:ArrayCollection;
		private var _measurementType:ArrayCollection;
		private var _overallType:ArrayCollection;
		
		private var _accelerationUnitsSelectedIndex:int;
		private var _velocityUnitsSelectedIndex:int;
		private var _displacementUnitsSelectedIndex:int;
		private var _frequencyUnitsSelectedIndex:int;
		private var _timeUnitsSelectedIndex:int;
		private var _temperatureUnitsSelectedIndex:int;
		private var _pressureUnitsSelectedIndex:int;
		private var _vibrationTypeSelectedIndex:int;
		private var _measurementTypeSelectedIndex:int;
		private var _overallTypeSelectedIndex:int;
		
		private var _displayedPrecision:int;
		private var _scientificNotationThreshold:int;
		
		private var _canSaveUserPreferences:Boolean = false;
		private var _canModifyUserPreferences:Boolean = false;
		
		private var _userId:int;
		private var _dp:UserPreference;
		private var _snt:UserPreference;
		private var _accRefLevel:UserPreference;
		private var _velRefLevel:UserPreference;
		private var _userPreferenceUnsetCount:int;
		private var _userPreferenceSetCount:int;
		private var _defaultAccelerationScale:Number = 1;
		private var _defaultVelocityScale:Number = 0.5;
		
		public static const GET_USER_PREFERENCES_COMPLETE:String = "getUserPreferencesComplete";

		// **** IMPORTANT! ****
		private const NUM_UNIT_PREFERENCES:int = 9; // the number of preferences the user can set. This needs to be set correctly in order to keep track of how many times to call the setUserPreference server method when saving.
		
		// These are all the properties that the view will bind to. 
		// We fire an event whenever one of these properties changes so the view knows to read it again (that's how data binding works) 

		[Bindable(event="defaultVelocityScaleChange")]
		public function get defaultVelocityScale():Number
		{
			return _defaultVelocityScale;
		}

		public function set defaultVelocityScale(value:Number):void
		{
			_defaultVelocityScale = value;
		}
		
		[Bindable(event="defaultAccelerationScaleChange")]
		public function get defaultAccelerationScale():Number
		{
			return _defaultAccelerationScale;
		}

		public function set defaultAccelerationScale(value:Number):void
		{
			_defaultAccelerationScale = value;
		}

		[Bindable(event="accelerationUnitsChange")]
		public function get accelerationUnits():ArrayCollection
		{
			return _accelerationUnits;
		}
		
		[Bindable(event="accelerationRefLevelChange")]
		public function get accelerationRefLevel():String
		{
			if (_accelerationRefLevel == null){
				return  "1";
			}else{
			    return _accelerationRefLevel;
			}
		}
		
	    [Bindable(event="velocityRefLevelChange")]
		public function get velocityRefLevel():String
		{
			if (_velocityRefLevel == null){
				return  "1";
			}else{
			    return _velocityRefLevel;
			}
		}
		
		public function get accelerationRefLevelNumber():Number{
			return new Number(accelerationRefLevel);
		}
		
	    public function get velocityRefLevelNumber():Number{
			return new Number(velocityRefLevel);
		}
		
		[Bindable(event="velocityUnitsChange")]
		public function get velocityUnits():ArrayCollection
		{
			return _velocityUnits;
		}
		
		[Bindable(event="displacementUnitsChange")]
		public function get displacementUnits():ArrayCollection
		{
			return _displacementUnits;
		}

		[Bindable(event="frequencyUnitsChange")]
		public function get frequencyUnits():ArrayCollection
		{
			return _frequencyUnits;
		}
		
		[Bindable(event="timeUnitsChange")]
		public function get timeUnits():ArrayCollection
		{
			return _timeUnits;
		}
																
		[Bindable(event="temperatureUnitsChange")]
		public function get temperatureUnits():ArrayCollection
		{
			return _temperatureUnits;
		}

		[Bindable(event="pressureUnitsChange")]
		public function get pressureUnits():ArrayCollection
		{
			return _pressureUnits;
		}

		[Bindable(event="vibrationTypeChange")]
		public function get vibrationType():ArrayCollection
		{
			return _vibrationType;
		}
		
		[Bindable(event="measurementTypeChange")]
		public function get measurementType():ArrayCollection
		{
			return _measurementType;
		}
		
		[Bindable(event="overallTypeChange")]
		public function get overallType():ArrayCollection
		{
			return _overallType;
		}
				
		[Bindable(event="accelerationUnitsSelectedIndexChange")]
		public function get accelerationUnitsSelectedIndex():int
		{
			return _accelerationUnitsSelectedIndex;
		}
		
		[Bindable(event="velocityUnitsSelectedIndexChange")]
		public function get velocityUnitsSelectedIndex():int
		{
			return _velocityUnitsSelectedIndex;
		}
		
		[Bindable(event="displacementUnitsSelectedIndexChange")]
		public function get displacementUnitsSelectedIndex():int
		{
			return _displacementUnitsSelectedIndex;
		}

		[Bindable(event="frequencyUnitsSelectedIndexChange")]
		public function get frequencyUnitsSelectedIndex():int
		{
			return _frequencyUnitsSelectedIndex;
		}
		
		[Bindable(event="timeUnitsSelectedIndexChange")]
		public function get timeUnitsSelectedIndex():int
		{
			return _timeUnitsSelectedIndex;
		}
												
		[Bindable(event="temperatureUnitsSelectedIndexChange")]
		public function get temperatureUnitsSelectedIndex():int
		{
			return _temperatureUnitsSelectedIndex;
		}

		[Bindable(event="pressureUnitsSelectedIndexChange")]
		public function get pressureUnitsSelectedIndex():int
		{
			return _pressureUnitsSelectedIndex;
		}

		[Bindable(event="vibrationTypeSelectedIndexChange")]
		public function get vibrationTypeSelectedIndex():int
		{
			return _vibrationTypeSelectedIndex;
		}
		
		[Bindable(event="measurementTypeSelectedIndexChange")]
		public function get measurementTypeSelectedIndex():int
		{
			return _measurementTypeSelectedIndex;
		}
		
		[Bindable(event="overallTypeSelectedIndexChange")]
		public function get overallTypeSelectedIndex():int
		{
			return _overallTypeSelectedIndex;
		}
		
		[Bindable(event="displayedPrecisionChange")]
		public function get displayedPrecision():int
		{
			if (_displayedPrecision == 0) {
				return 4;
			} else {
				return _displayedPrecision;
			}
		}
		
		[Bindable(event="scientificNotationThresholdChange")]
		public function get scientificNotationThreshold():int
		{
			if (_scientificNotationThreshold == 0) {
				return 3;
			} else {
				return _scientificNotationThreshold;
			}
		}
				
		[Bindable(event="canSaveUserPreferencesChange")]
		public function get canSaveUserPreferences():Boolean
		{
			return _canSaveUserPreferences;
		}

		[Bindable(event="canModifyUserPreferencesChange")]
		public function get canModifyUserPreferences():Boolean
		{
			return _canModifyUserPreferences;
		}		
		
		public function set userId(value:int):void
		{
			_userId = value;
			getAvailableUserPreferences();
		}
								
		public function UserPreferencesModel()
		{
			super();
		}

		public function saveUserPreferences():void 
		{
			if (validateUserPreferences()){
			  enableSaveUserPreferences(false);
			  enableModifyUserPreferences(false);
			  // before saving the new user preferences, we first we need to unset all the previous user preferences
			  _userPreferenceUnsetCount = 0;
			  if (_userPreferences.length > 0)
			  {
				  for each (var userPreference:UserPreference in _userPreferences)
			  	  {
					  unsetUserPreference(_userId, userPreference.id);
				  }
			  }
			  else
			  {
				  // this condition should only execute if there were zero user preferences for this user returned from the database.  In that case, there are none that need to first be unset and we can just proceed.
				  unsetUserPreferencesComplete();
			  }
			}
		}
		
		private function validateUserPreferences():Boolean{
			
			if (isNaN(accelerationRefLevelNumber) || (accelerationRefLevelNumber<0)){
				return false;
			}
			if (isNaN(velocityRefLevelNumber) || (velocityRefLevelNumber<0)){
				return false;
			}
			return true;
		}
		
		private function unsetUserPreferencesComplete():void
		{
			// we have to match up the user preferences selected with their respective userPreference object and then call setUserPreference() with the userPreference.id
			var accelerationValue:String = _accelerationUnits.getItemAt(_accelerationUnitsSelectedIndex) as String;
			var velocityValue:String = _velocityUnits.getItemAt(_velocityUnitsSelectedIndex) as String;
			var displacementValue:String = _displacementUnits.getItemAt(_displacementUnitsSelectedIndex) as String;
			var frequencyValue:String = _frequencyUnits.getItemAt(_frequencyUnitsSelectedIndex) as String;
			var timeValue:String = _timeUnits.getItemAt(_timeUnitsSelectedIndex) as String;
			var temperatureValue:String = _temperatureUnits.getItemAt(_temperatureUnitsSelectedIndex) as String;
			var pressureValue:String = _pressureUnits.getItemAt(_pressureUnitsSelectedIndex) as String;
			var vibrationValue:String = _vibrationType.getItemAt(_vibrationTypeSelectedIndex) as String;
			var measurementValue:String = _measurementType.getItemAt(_measurementTypeSelectedIndex) as String;
			var overallValue:String = _overallType.getItemAt(_overallTypeSelectedIndex) as String;
			// now save (set) each user preference on the server
			
			_dp.value = String(_displayedPrecision);
			updateUserPreferece(_dp);
			_snt.value = String(_scientificNotationThreshold);
			updateUserPreferece(_snt);
			_accRefLevel.value = _accelerationRefLevel;
			updateUserPreferece(_accRefLevel);
			_velRefLevel.value = _velocityRefLevel;
			updateUserPreferece(_velRefLevel);
			
			_userPreferenceSetCount = 0;
			for each (var userPreference:UserPreference in _availableUserPreferences)
			{
				switch (userPreference.type)
				{
					case "Acceleration":
					{
						if (userPreference.value == accelerationValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}					
					case "Velocity":
					{
						if (userPreference.value == velocityValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Displacement":
					{
						if (userPreference.value == displacementValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Frequency":
					{
						if (userPreference.value == frequencyValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Time":
					{
						if (userPreference.value == timeValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}					
					case "Temperature":
					{
						if (userPreference.value == temperatureValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Pressure":
					{
						if (userPreference.value == pressureValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Vibration":
					{
						if (userPreference.value == vibrationValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}	
					case "Measurement":
					{
						if (userPreference.value == measurementValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					case "Overall":
					{
						if (userPreference.value == overallValue)
							setUserPreference(_userId, userPreference.id);
						break;
					}
					default:
					{
						break;
					}					
				}
			}
		}
		
		private function updateUserPreferece(up:UserPreference):void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.updateUserPreference(up);
		}

		// this function belongs in a services class
		private function getAvailableUserPreferences():void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onGetAvailableUserPreferencesResult);
			ro.addEventListener(FaultEvent.FAULT, onGetAvailableUserPreferencesFault);
			ro.getAvailableUserPreferences();
		}

		private function onGetAvailableUserPreferencesResult(event:ResultEvent):void
		{
			if (event.result != null)
			{
				_availableUserPreferences = event.result as ArrayCollection;
				_accelerationUnits = new ArrayCollection();
				_velocityUnits = new ArrayCollection();
				_displacementUnits = new ArrayCollection();
				_frequencyUnits = new ArrayCollection();
				_timeUnits = new ArrayCollection();
				_temperatureUnits = new ArrayCollection();
				_pressureUnits = new ArrayCollection();
				_vibrationType = new ArrayCollection();
				_measurementType = new ArrayCollection();
				_overallType = new ArrayCollection();
				for each (var userPreference:UserPreference in _availableUserPreferences)
				{
					switch (userPreference.type)
					{
						case "Acceleration":
						{
							_accelerationUnits.addItem(userPreference.value);
							break;
						}
						case "Velocity": 
						{
							_velocityUnits.addItem(userPreference.value);
							break;
						}
						case "Displacement": 
						{
							_displacementUnits.addItem(userPreference.value);
							break;
						}
						case "Frequency": 
						{
							_frequencyUnits.addItem(userPreference.value);
							break;
						}
						case "Time": 
						{
							_timeUnits.addItem(userPreference.value);
							break;
						}						
						case "Temperature": 
						{
							_temperatureUnits.addItem(userPreference.value);
							break;
						}
						case "Pressure": 
						{
							_pressureUnits.addItem(userPreference.value);
							break;
						}	
						case "Vibration":
						{
							_vibrationType.addItem(userPreference.value);
							break;
						}
						case "Measurement":
						{
							_measurementType.addItem(userPreference.value);
							break;
						}
						case "Overall":
						{
							_overallType.addItem(userPreference.value);
							break;
						}
						default:
						{
							break;
						}											
					}
				}
				dispatchEvent(new Event("accelerationUnitsChange"));
				dispatchEvent(new Event("velocityUnitsChange"));
				dispatchEvent(new Event("displacementUnitsChange"));
				dispatchEvent(new Event("frequencyUnitsChange"));
				dispatchEvent(new Event("timeUnitsChange"));
				dispatchEvent(new Event("temperatureUnitsChange"));
				dispatchEvent(new Event("pressureUnitsChange"));
				dispatchEvent(new Event("vibrationTypeChange"));
				dispatchEvent(new Event("measurementTypeChange"));
				dispatchEvent(new Event("overallTypeChange"));
				getUserPreferences(_userId);
			}
			else
			{
				Alert.show('An error occurred.', 'Error');
			}
		}
		
		private function onGetAvailableUserPreferencesFault(event:FaultEvent):void
		{
			Alert.show('Error: ' + event.fault.faultString, 'Error Occurred');
		}

		// this function belongs in a services class
		private function getUserPreferences(userId:int):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onGetUserPreferencesResult);
			ro.addEventListener(FaultEvent.FAULT, onGetUserPreferencesFault);
			ro.getUserPreferences(userId);
		}

		private function onGetUserPreferencesResult(event:ResultEvent):void
		{
			if (event.result != null)
			{
				_userPreferences = event.result as ArrayCollection;
				for each (var userPreference:UserPreference in _userPreferences)
				{
					switch (userPreference.type)
					{
						case "Acceleration":
						{
							_accelerationUnitsSelectedIndex = _accelerationUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("accelerationUnitsSelectedIndexChange"));
							break;
						}						
						case "Velocity":
						{
							_velocityUnitsSelectedIndex = _velocityUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("velocityUnitsSelectedIndexChange"));
							break;
						}
						case "Displacement":
						{
							_displacementUnitsSelectedIndex = _displacementUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("displacementUnitsSelectedIndexChange"));
							break;
						}
						case "Frequency":
						{
							_frequencyUnitsSelectedIndex = _frequencyUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("frequencyUnitsSelectedIndexChange"));
							break;
						}
						case "Time":
						{
							_timeUnitsSelectedIndex = _timeUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("timeUnitsSelectedIndexChange"));
							break;
						}						
						case "Temperature":
						{
							_temperatureUnitsSelectedIndex = _temperatureUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("temperatureUnitsSelectedIndexChange"));
							break;
						}	
						case "Pressure":
						{
							_pressureUnitsSelectedIndex = _pressureUnits.getItemIndex(userPreference.value);
							dispatchEvent(new Event("pressureUnitsSelectedIndexChange"));
							break;
						}	
						case "Vibration":
						{
							_vibrationTypeSelectedIndex = _vibrationType.getItemIndex(userPreference.value);
							dispatchEvent(new Event("vibrationTypeSelectedIndexChange"));
							break;
						}			
						case "Measurement":
						{
							_measurementTypeSelectedIndex = _measurementType.getItemIndex(userPreference.value);
							dispatchEvent(new Event("measurementTypeSelectedIndexChange"));
							break;
						}
						case "Overall":
						{
							_overallTypeSelectedIndex = _overallType.getItemIndex(userPreference.value);
							dispatchEvent(new Event("overallTypeSelectedIndexChange"));
							break;
						}			
						case "DisplayedPrecision":
						{
							_displayedPrecision = Number(userPreference.value);
							dispatchEvent(new Event("displayedPrecisionChange"));
							_dp = userPreference;
							break;
						}	
						case "AccelerationRefLevel":
						{
							_accelerationRefLevel = userPreference.value;
							dispatchEvent(new Event("accelerationRefLevelChange"));
							_accRefLevel = userPreference;
							break;
						}
						case "defaultAccelerationScale":
						{
							_defaultAccelerationScale = Number(userPreference.value);
							dispatchEvent(new Event("defaultAccelerationScaleChange"));
							break;
						}
						case "VelocityRefLevel":
						{
							_velocityRefLevel = userPreference.value;
							dispatchEvent(new Event("velocityRefLevelChange"));
							_velRefLevel = userPreference;
							break;
						}
						case "defaultVelocityScale":
						{
							_defaultVelocityScale = Number(userPreference.value);
							dispatchEvent(new Event("defaultVelocityScaleChange"));
							break;
						}
						case "ScientificNotationThreshold":
						{
							_scientificNotationThreshold = Number(userPreference.value);
							dispatchEvent(new Event("scientificNotationThresholdChange"));
							_snt = userPreference;
							break;
						}	
					}
				}
				if (_dp) {
					_userPreferences.removeItemAt(_userPreferences.getItemIndex(_dp));
				} 
				if (_snt) {
					_userPreferences.removeItemAt(_userPreferences.getItemIndex(_snt));
				}
				if (_accRefLevel) {
					_userPreferences.removeItemAt(_userPreferences.getItemIndex(_accRefLevel));
				}
				if (_velRefLevel) {
					_userPreferences.removeItemAt(_userPreferences.getItemIndex(_velRefLevel));
				}
				
				enableModifyUserPreferences(true);
				dispatchEvent(new Event(GET_USER_PREFERENCES_COMPLETE));
			}
			else
			{
				Alert.show('An error occurred.', 'Error');
			}
		}
		
		private function onGetUserPreferencesFault(event:FaultEvent):void
		{
			Alert.show('Error: ' + event.fault.faultString, 'Error Occurred');
		}
				
		// this function belongs in a services class
		private function unsetUserPreference(userId:int, userPreferenceId:int):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onUnsetUserPreferenceResult);
			ro.addEventListener(FaultEvent.FAULT, onUnsetUserPreferenceFault);
			ro.unsetUserPreference(userId, userPreferenceId);			
		}
		
		private function createUserPreference(up:UserPreference): void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.createUserPreference(up);		
		}
		
		private function onUnsetUserPreferenceResult(event:ResultEvent):void
		{
			if (event.result != null && event.result.status == 0)
			{
				_userPreferenceUnsetCount++;
				if (_userPreferenceUnsetCount == _userPreferences.length)
				{
					// all preferences for this user have been unset.  Now we can set the new ones
					unsetUserPreferencesComplete();
				}
			}
			else
			{
				Alert.show(event.result.message, 'Error');
			}
		}
		
		private function onUnsetUserPreferenceFault(event:FaultEvent):void
		{
			Alert.show('Error: ' + event.fault.faultString, 'Error Occurred');
		}

		// this function belongs in a services class
		private function setUserPreference(userId:int, userPreferenceId:int):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onSetUserPreferenceResult);
			ro.addEventListener(FaultEvent.FAULT, onSetUserPreferenceFault);
			ro.setUserPreference(userId, userPreferenceId);			
		}
		
		private function onSetUserPreferenceResult(event:ResultEvent):void
		{
			if (event.result != null && event.result.status == 0)
			{
				_userPreferenceSetCount++;
				if (_userPreferenceSetCount == NUM_UNIT_PREFERENCES)
				{
					// all preferences for this user have been set.
					getUserPreferences(_userId); // reload the user preferences from the server
				}
			}
			else
			{
				Alert.show(event.result.message, 'Error');
			}
		}
		
		private function onSetUserPreferenceFault(event:FaultEvent):void
		{
			Alert.show('Error: ' + event.fault.faultString, 'Error Occurred');
		}
				
		public function updateAccelerationUnitsSelectedIndex(value:int):void
		{
			_accelerationUnitsSelectedIndex = value;
			dispatchEvent(new Event("accelerationUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateAccelerationRefLevel(value:String):void
		{
			_accelerationRefLevel= value;
			dispatchEvent(new Event("accelerationRefLevelChange"));
			enableSaveUserPreferences();
		}
		
		public function updateDefaultAccelerationScale(value:Number):void
		{
			_defaultAccelerationScale = value;
			dispatchEvent(new Event("defaultAccelerationScaleChange"));
			enableSaveUserPreferences();
		}
		
		public function updateVelocityRefLevel(value:String):void
		{
			_velocityRefLevel= value;
			dispatchEvent(new Event("velocityRefLevelChange"));
			enableSaveUserPreferences();
		}

		public function updateDefaultVelocityScale(value:Number):void
		{
			_defaultVelocityScale = value;
			dispatchEvent(new Event("defaultVelocityScaleChange"));
			enableSaveUserPreferences();
		}
		
		public function updateVelocityUnitsSelectedIndex(value:int):void
		{
			_velocityUnitsSelectedIndex = value;
			dispatchEvent(new Event("velocityUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateDisplacementUnitsSelectedIndex(value:int):void
		{
			_displacementUnitsSelectedIndex = value;
			dispatchEvent(new Event("displacementUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}

		public function updateFrequencyUnitsSelectedIndex(value:int):void
		{
			_frequencyUnitsSelectedIndex = value;
			dispatchEvent(new Event("frequencyUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateTimeUnitsSelectedIndex(value:int):void
		{
			_timeUnitsSelectedIndex = value;
			dispatchEvent(new Event("timeUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
										
		public function updateTemperatureUnitsSelectedIndex(value:int):void
		{
			_temperatureUnitsSelectedIndex = value;
			dispatchEvent(new Event("temperatureUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updatePressureUnitsSelectedIndex(value:int):void
		{
			_pressureUnitsSelectedIndex = value;
			dispatchEvent(new Event("pressureUnitsSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateVibrationTypeSelectedIndex(value:int):void
		{
			_vibrationTypeSelectedIndex = value;
			dispatchEvent(new Event("vibrationTypeSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateMeasurementTypeSelectedIndex(value:int):void
		{
			_measurementTypeSelectedIndex = value;
			dispatchEvent(new Event("measurementTypeSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateOverallTypeSelectedIndex(value:int):void
		{
			_overallTypeSelectedIndex = value;
			dispatchEvent(new Event("overallTypeSelectedIndexChange"));
			enableSaveUserPreferences();
		}
		
		public function updateDisplayedPrecision(value:int):void
		{
			_displayedPrecision = value;
			dispatchEvent(new Event("displayedPrecisionChange"));
			enableSaveUserPreferences();
		}
		
		public function updateScientificNotationThreshold(value:int):void
		{
			_scientificNotationThreshold = value;
			dispatchEvent(new Event("scientificNotationThresholdChange"));
			enableSaveUserPreferences();
		}
				
		private function enableSaveUserPreferences(enable:Boolean = true):void
		{
			_canSaveUserPreferences = enable;
			dispatchEvent(new Event("canSaveUserPreferencesChange"));
		}
		
		private function enableModifyUserPreferences(enable:Boolean = true):void
		{
			_canModifyUserPreferences = enable;
			dispatchEvent(new Event("canModifyUserPreferencesChange"));			
		}
	}
}