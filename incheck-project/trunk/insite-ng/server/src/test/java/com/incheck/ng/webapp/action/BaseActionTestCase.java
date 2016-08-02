package com.incheck.ng.webapp.action;

import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.struts2.ServletActionContext;
import org.junit.After;
import org.junit.Before;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;

import com.incheck.ng.Constants;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.config.Configuration;
import com.opensymphony.xwork2.config.ConfigurationManager;
import com.opensymphony.xwork2.config.providers.XWorkConfigurationProvider;
import com.opensymphony.xwork2.inject.Container;
import com.opensymphony.xwork2.util.LocalizedTextUtil;
import com.opensymphony.xwork2.util.ValueStack;
import com.opensymphony.xwork2.util.ValueStackFactory;

/**
 * Base class for running Struts 2 Action tests.
 * 
 */
@ContextConfiguration(locations = { "classpath:/applicationContext-service.xml" })
public abstract class BaseActionTestCase extends AbstractSpringTestContextEnabledIntegrationTestSupport {
    /**
     * Transient log to prevent session synchronization issues - children can
     * use instance for logging.
     */
    protected transient final Log log = logger;
    private int smtpPort = 25250;

    @Before
    public void onSetUp() {
        smtpPort = smtpPort + (int) (Math.random() * 100);

        LocalizedTextUtil.addDefaultResourceBundle(Constants.BUNDLE_KEY);

        // Initialize ActionContext
        ConfigurationManager configurationManager = new ConfigurationManager();
        configurationManager.addContainerProvider(new XWorkConfigurationProvider());
        Configuration config = configurationManager.getConfiguration();
        Container container = config.getContainer();

        ValueStack stack = container.getInstance(ValueStackFactory.class).createValueStack();
        stack.getContext().put(ActionContext.CONTAINER, container);
        ActionContext.setContext(new ActionContext(stack.getContext()));

        ActionContext.getContext().setSession(new HashMap<String, Object>());

        // change the port on the mailSender so it doesn't conflict with an
        // existing SMTP server on localhost
        JavaMailSenderImpl mailSender = (JavaMailSenderImpl) applicationContext.getBean("mailSender");
        mailSender.setPort(getSmtpPort());
        mailSender.setHost("localhost");

        // populate the request so getRequest().getSession() doesn't fail in
        // BaseAction.java
        ServletActionContext.setRequest(new MockHttpServletRequest());
    }

    protected int getSmtpPort() {
        return smtpPort;
    }

    @After
    public void onTearDown() {
        if (ActionContext.getContext() != null) {
            ActionContext.getContext().setSession(null);
        }
    }
}
