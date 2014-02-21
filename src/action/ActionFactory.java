package action;

import java.util.*;
import org.apache.log4j.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;

public class ActionFactory {
	
	private static final Logger logger = Logger.getLogger(ActionFactory.class);	
	private static ActionFactory instance = new ActionFactory();

	private ActionFactory() {}
	
	public static ActionFactory getInstance() {
		logger.info("Getting ActionFactory");
		return instance;
	}
	
	public HttpAction build(String actionName) throws WrongCommandException {
		try {
			logger.info("Building HttpAction");

			ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
			return (HttpAction) context.getBean(actionName);
		}
		catch (Exception e) {
			logger.error("Error in ActionFactory: wrong command", e);
			throw new WrongCommandException(e);
		}
	}
}