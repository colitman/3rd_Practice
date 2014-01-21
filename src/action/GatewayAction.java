package action;

import hibernate.dao.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;

public abstract class GatewayAction implements HttpAction {

	protected Gateway getGateway() {
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		return (Gateway) context.getBean("oracleGateway");
	}
}