package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.util.Collection;

public class ShowAllCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all cities");

			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<City> gateway = (Gateway<City>) context.getBean("oracleGateway");
			Collection<City> cities = gateway.getAll(City.class);
		
			logger.info("Get all cities");

			request.getSession().setAttribute("cities", cities);

			logger.info("Set all cities into session");
			logger.info("Send redirect to showAllCity page");
		
			response.sendRedirect("/WebPrototype/city/showAll.jsp");
		}
		catch (Exception e) {
			try {
				logger.warn("Error was occured");
				logger.info("Send redirect to error page");
				response.sendRedirect("/WebPrototype/error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {
				logger.error("Critical error was occured");
			}
		}
	}
}