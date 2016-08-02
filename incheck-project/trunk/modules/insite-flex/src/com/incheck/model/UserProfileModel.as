// This is the presentation model for UserProfileView
package com.incheck.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class UserProfileModel extends EventDispatcher
	{				
		private var _username:String;
		private var _password:String;
		private var _confirmPassword:String;
		private var _confirmPasswordErrorMessage:String;
		private var _canSaveUserProfile:Boolean = false;
						
		[Bindable(event="usernameChange")]
		public function get username():String
		{
			return _username;
		}

		[Bindable(event="passwordChange")]
		public function get password():String
		{
			return _password;
		}	

		[Bindable(event="confirmPasswordChange")]
		public function get confirmPassword():String
		{
			return _confirmPassword;
		}	

		[Bindable(event="confirmPasswordErrorMessageChange")]
		public function get confirmPasswordErrorMessage():String
		{
			return _confirmPasswordErrorMessage;
		}	
										
		[Bindable(event="canSaveUserProfileChange")]
		public function get canSaveUserProfile():Boolean
		{
			return _canSaveUserProfile;
		}
						
		public function UserProfileModel()
		{
			clearForm();
		}

		public function saveUserProfile():void 
		{
			enableSaveUserProfile(false, false);
			updateUserPass(_username, _password)
		}
		
		// this function belongs in a services class
		private function updateUserPass(username:String, password:String):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onUpdateUserPassResult);
			ro.addEventListener(FaultEvent.FAULT, onUpdateUserPassFault);
			ro.updateUserPass(username, password);			
		}
		
		private function onUpdateUserPassResult(event:ResultEvent):void
		{
			if (event.result != null && event.result.status == 0)
			{
				Alert.show(event.result.message, 'Success');
			}
			else
			{
				Alert.show(event.result.message, 'Error');
			}
		}
		
		private function onUpdateUserPassFault(event:FaultEvent):void
		{
			Alert.show('Error: ' + event.fault.faultString, 'Error Occurred');
		}
						
		public function clearForm():void
		{
			updateUsername('');
			updatePassword('');
			updateConfirmPassword('');
		}
		
		public function updateUsername(value:String):void
		{
			_username = value;
			dispatchEvent(new Event("usernameChange"));
			enableSaveUserProfile();
		}
		
		public function updatePassword(value:String):void
		{
			_password = value;
			dispatchEvent(new Event("passwordChange"));
			enableSaveUserProfile();
		}

		public function updateConfirmPassword(value:String):void
		{
			_confirmPassword = value;
			dispatchEvent(new Event("confirmPasswordChange"));
			_confirmPasswordErrorMessage = (_confirmPassword == _password) ? '' : 'Passwords must match';
			dispatchEvent(new Event("confirmPasswordErrorMessageChange"));
			enableSaveUserProfile();
		}
				
		private function enableSaveUserProfile(doCheck:Boolean = true, enable:Boolean = true):void
		{
			if (doCheck)
			{
				_canSaveUserProfile = (_username != '' && _password != '' && (_password == _confirmPassword)) ? true : false;
			}
			else
			{
				// no checking -- just force to the value passed in 
				_canSaveUserProfile = enable;
			}
			dispatchEvent(new Event("canSaveUserProfileChange"));
		}
	}
}