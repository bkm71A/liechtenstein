package com.inchecktech.dpm.auth;

import java.io.IOException;

import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.TextOutputCallback;
import javax.security.auth.callback.UnsupportedCallbackException;

public class InCheckLoginCallback implements CallbackHandler {
	private  String userName;
	private  String password;
	private  String message;

	public InCheckLoginCallback(String username, String password)
	{
		this.userName = username;
		this.password = password;
		this.message = "";
	}
	
	public String getMessage()
	{
		return this.message;
	}

	public void handle(Callback[] callbacks) throws IOException,
			UnsupportedCallbackException {

		for (int i = 0; i < callbacks.length; i++) {
			if (callbacks[i] instanceof TextOutputCallback) {

				// display the message according to the specified type
				TextOutputCallback toc = (TextOutputCallback) callbacks[i];
				message += "\n";
				switch (toc.getMessageType()) {
				case TextOutputCallback.INFORMATION:
					message += "INFO: ";
					break;
				case TextOutputCallback.ERROR:
					message += "ERROR";
					break;
				case TextOutputCallback.WARNING:
					message += "WARNING";
					break;
				default:
					throw new IOException("Unsupported message type: "
							+ toc.getMessageType());
				}
				this.message += toc.getMessage();

			} else if (callbacks[i] instanceof NameCallback) {
				NameCallback nc = (NameCallback) callbacks[i];
				nc.setName(this.userName);
			} else if (callbacks[i] instanceof PasswordCallback) {
				PasswordCallback pc = (PasswordCallback) callbacks[i];
				pc.setPassword(this.password.toCharArray());
			} else {
				throw new UnsupportedCallbackException(callbacks[i],
						"Unrecognized Callback");
			}
		}
	}
}