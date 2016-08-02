package com.inchecktech.dpm.jms;


/*
import javax.jms.JMSException;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.jms.Topic;
import javax.jms.TopicConnection;
import javax.jms.TopicConnectionFactory;
import javax.jms.TopicPublisher;
import javax.jms.TopicSession;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
*/
/**
 * @deprecated Do not use this class
 * This method will publish a text message to provided topic
 *
 */
@Deprecated public class Publisher {

	/*
	
	private TextMessage message;
	private String providerURL;
	private String topicName = null;
	private Context jndiContext = null;
	private TopicConnectionFactory topicConnectionFactory = null;
	private TopicConnection topicConnection = null;
	private TopicSession topicSession = null;
	private Topic topic = null;
	private TopicPublisher topicPublisher = null;
	Hashtable<String, String> env;

	public Publisher(String providerURL, String topicName) {

		if (null == topicName && topicName.equals(""))
			throw new IllegalArgumentException(
					"topicName can't be null or empty");

		if (null == providerURL && providerURL.equals(""))
			throw new IllegalArgumentException(
					"topicName can't be null or empty");

		this.topicName = topicName;
		this.providerURL = providerURL;
		
		

		// For JBOSS Security
		System.setProperty("java.security.policy", "client.policy");
		if (System.getSecurityManager() == null)
			System.setSecurityManager(new RMISecurityManager());

		// JBOSS specific
		env = new Hashtable<String, String>();
		env.put(Context.INITIAL_CONTEXT_FACTORY,
				"org.jnp.interfaces.NamingContextFactory");
		env.put(Context.PROVIDER_URL, providerURL);
		env
				.put(Context.URL_PKG_PREFIXES,
						"org.jboss.naming:org.jnp.interfaces");
		
		

	}

	public void publish(String msg) {
		System.out.println("Info: publishing message " + message + " to topic "
				+ topicName);
		
		 try {
			  jndiContext = new InitialContext(env);
	           topicConnectionFactory = (TopicConnectionFactory)
	               jndiContext.lookup("TopicConnectionFactory");
	           topic = (Topic) jndiContext.lookup(topicName);
	       } catch (NamingException e) {
	           System.out.println("JNDI API lookup failed: " +
	               e.toString());
	           e.printStackTrace();
	           
	           //TODO: this should be disabled in running within container.
	           System.exit(1);
	       }

	       
	       try {
	           topicConnection = 
	               topicConnectionFactory.createTopicConnection();
	           topicSession = 
	               topicConnection.createTopicSession(false, 
	                   Session.AUTO_ACKNOWLEDGE);
	           topicPublisher = topicSession.createPublisher(topic);
	           message = topicSession.createTextMessage();
	           message.setText(msg);
	           
	           System.out.println("Publishing message: " +   message.getText());
	           topicPublisher.publish(message);
	           
	       } catch (JMSException e) {
	           System.out.println("Exception occurred: " + 
	               e.toString());
	       } finally {
	           if (topicConnection != null) {
	               try {
	                   topicConnection.close();
	               } catch (JMSException e) {}
	           }
	       }
	 
	}
*/
}
