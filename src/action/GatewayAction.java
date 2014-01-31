package action;

import hibernate.dao.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;

public abstract class GatewayAction implements HttpAction {

	private static final Logger logger = Logger.getLogger("logger");	

	protected Gateway getGateway() {
		logger.info("Getting gateway...");
		ApplicationContext context = new ClassPathXmlApplicationContext("res/beans.xml");
		return (Gateway) context.getBean("oracleGateway");
	}
}