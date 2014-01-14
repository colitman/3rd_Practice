package action;

import hibernate.dao.*;

public abstract class GatewayAction implements Action {

	protected Gateway getGateway() {
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		return (Gateway) context.getBean("oracleGateway");
	}
}