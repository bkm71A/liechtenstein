// This is the presentation model for LoginView
package com.incheck.admin.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class LoginModel extends EventDispatcher
	{				
		private var _username:String;
		private var _password:String;
		private var _canLogin:Boolean = false;
		private var _canEmailPassword:Boolean = false;
		private var _currentState:String = '';
		private var _messageTitle:String = '';
		private var _messageHTMLText:String = '';
		
		public static const LOGIN_COMPLETE:String = "loginComplete";
				
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
						
		[Bindable(event="canLoginChange")]
		public function get canLogin():Boolean
		{
			return _canLogin;
		}

		[Bindable(event="canEmailPasswordChange")]
		public function get canEmailPassword():Boolean
		{
			return _canEmailPassword;
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String
		{
			return _currentState;
		}

		[Bindable(event="messageTitleChange")]
		public function get messageTitle():String
		{
			return _messageTitle;
		}
		
		[Bindable(event="messageHTMLTextChange")]
		public function get messageHTMLText():String
		{
			return _messageHTMLText;
		}
						
		public function LoginModel()
		{
			clearLogin();
		}

		public function login():void 
		{
			enableLogin(false, false);
			processUserLogin(_username, _password)
		}
		
		// this function belongs in a services class
		private function processUserLogin(username:String, password:String):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onProcessUserLoginResult);
			ro.addEventListener(FaultEvent.FAULT, onProcessUserLoginFault);
			ro.processUserLogin(username, password);			
		}
		
		private function onProcessUserLoginResult(event:ResultEvent):void
		{
			if (event.result != null && event.result.status == 0)
			{
				var obj:Object = event.result.user;
				if (obj != null && obj is User)
				{
					var user:User = obj as User;
					dispatchEvent(new Event(LOGIN_COMPLETE));
				}
			}
			else
			{
				setLoginMessage('Error - Login Failed', event.result.message);
			}
		}
		
		private function onProcessUserLoginFault(event:FaultEvent):void
		{
			setLoginMessage('Error', event.toString());
		}
		
		public function emailPassword():void
		{
			enableEmailPassword	(false, false);
			resetUserPassword(_username);
		}

		// this function belongs in a services class
		private function resetUserPassword(username:String):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, onResetUserPasswordResult);
			ro.addEventListener(FaultEvent.FAULT, onResetUserPasswordFault);
			ro.resetUserPassword(username);			
		}

		private function onResetUserPasswordResult(event:ResultEvent):void
		{
			if (event.result != null && event.result.status == 0)
			{
				setLoginMessage('Reset Password Request Successful', event.result.message);
			}
			else
			{
				setLoginMessage('Error - Reset Password Failed', event.result.message);
			}
		}
		
		private function onResetUserPasswordFault(event:FaultEvent):void
		{
			setLoginMessage('Error', event.toString());
		}
						
		private function setLoginMessage(title:String, message:String):void
		{
			_messageTitle = title;
			dispatchEvent(new Event("messageTitleChange"));
			_messageHTMLText = message;
			dispatchEvent(new Event("messageHTMLTextChange"));
			switchToMessage();	
			enableLogin();	
			enableEmailPassword();				
		}
						
		public function clearLogin():void
		{
			updateUsername('');
			updatePassword('');
		}
		
		public function updateUsername(value:String):void
		{
			_username = value;
			dispatchEvent(new Event("usernameChange"));
			enableLogin();
			enableEmailPassword();
		}
		
		public function updatePassword(value:String):void
		{
			_password = value;
			dispatchEvent(new Event("passwordChange"));
			enableLogin();
		}
		
		public function switchToLogin():void
		{
			_currentState = '';	
			dispatchEvent(new Event("currentStateChange"));		
		}
		
		public function switchToEmailPassword():void
		{
			_currentState = 'emailPassword';
			dispatchEvent(new Event("currentStateChange"));				
		}
		
		public function switchToMessage():void
		{
			_currentState = ''; // this is needed because you always have to start at the original state.  You can't go from emailPassword directly to message. Is there another way to do states?
			dispatchEvent(new Event("currentStateChange"));	
			_currentState = 'message';
			dispatchEvent(new Event("currentStateChange"));	
		}

		public function cancelForgotAccount():void
		{
			_currentState = '';
			dispatchEvent(new Event("currentStateChange"));	
		}
				
		private function enableLogin(doCheck:Boolean = true, enable:Boolean = true):void
		{
			if (doCheck)
			{
				_canLogin = (_username != '' && _password != '') ? true : false;
			}
			else
			{
				// no checking -- just force to the value passed in 
				_canLogin = enable;
			}
			dispatchEvent(new Event("canLoginChange"));

		}
		
		private function enableEmailPassword(doCheck:Boolean = true, enable:Boolean = true):void
		{
			if (doCheck)
			{
				_canEmailPassword = (_username != '') ? true : false;
			}
			else
			{
				// no checking -- just force to the value passed in 
				_canEmailPassword = enable;
			}
			dispatchEvent(new Event("canEmailPasswordChange"));
		}
 
	}
}