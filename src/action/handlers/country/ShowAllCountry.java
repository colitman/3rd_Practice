package action.handlers.country;

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

public class ShowAllCountry implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all countries");
	
			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<Country> gateway = (Gateway<Country>) context.getBean("oracleGateway");
			Collection<Country> countries = gateway.getAll(Country.class);

			logger.info("Get all countries");		

			request.getSession().setAttribute("countries", countries);
		
			logger.info("Set all countries into session");
			logger.info("Send redirect to showAllCountry page");

			response.sendRedirect("/WebPrototype/country/showAll.jsp");
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