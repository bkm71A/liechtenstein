package com.inchecktech.dpm.notifications;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

/**
 * To send email, activation.jar, commons-email-1.0.jar, mail.jar need to be in
 * the <APACHE_HOME>/common/lib
 * 
 * @author vlad gusev
 * 
 */

public class MailProxy {
	public static MailProxy p;

	public static final String REGISRATION_EMAIL_BODY = "Thank you for your interest in InCheck Technologies products and services."
			+ " Our server has received your registration information. "
			+ " To complete your registration please click on the link that follows or copy paste it into your browser address window.";

	private static final String mailsession_name = "mail/Session";
	
	public static MailProxy getInstance(){
		if (null == p){
			p = new MailProxy();
			return p;
		}
		
		return p;
	}

	private Session getEmailSession() {

		Context initCtx = null;
		Session session = null;
		Context envCtx = null;

		try {
			initCtx = new InitialContext();
			envCtx = (Context) initCtx.lookup("java:comp/env");
			session = (Session) envCtx.lookup(mailsession_name);
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return session;
	}

	public void sendSimpleEmail(String fromAddress, String toAddress,
			String subject, String body) throws Exception {

		String to[] = new String[1];
		to[0] = toAddress;
		sendSimpleEmail(fromAddress, to, subject, body);
	}

	public void sendSimpleEmail(String fromAddress, String[] toAddress,
			String subject, String body) throws Exception {

		Message message = new MimeMessage(getEmailSession());
		message.setFrom(new InternetAddress(fromAddress));
		InternetAddress to[] = new InternetAddress[toAddress.length];

		for (int i = 0; i < toAddress.length; i++) {
			to[i] = new InternetAddress(toAddress[i]);
		}

		message.setRecipients(Message.RecipientType.TO, to);
		message.setSubject(subject);
		message.setContent(body, "text/plain");
		Transport.send(message);

	}

	
	@SuppressWarnings("unused")
	private void sendHtmlEmail(String fromAddress, String toAddress,
			String toAddressText, String subject, String body) {
		try {

			HtmlEmail email = new HtmlEmail();
			email.setMailSession(getEmailSession());
			email.setFrom(fromAddress, toAddressText);
			email.addTo(toAddress);
			email.setSubject(subject);
			// email.embed(new URL(css_url), "CSS");
			// email.embed(new URL(logo_url), "LOGO");
			email.setHtmlMsg(body);
			// email.setTextMsg("Your email client does not support HTML
			// messages, sorry");
			email.send();
		} catch (EmailException e) {
			e.printStackTrace();
		}

	}

}
