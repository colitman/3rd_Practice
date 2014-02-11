package action;

import hibernate.dao.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;

public class GatewayResolver {

	private static final Logger logger = Logger.getLogger(GatewayResolver.class);

	public static Gateway getGateway() {
		logger.info("Getting gateway");
		ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
		return (Gateway) context.getBean("oracleGateway");
	}
}