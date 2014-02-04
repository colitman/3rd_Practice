package action.handlers.country;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import org.apache.log4j.xml.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.util.Collection;

public class ShowAllCountry extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			DOMConfigurator.configure("log4j.xml");
			logger.info("Logger installed");
			logger.info("Prepare to show all countries");
	
			Gateway<Country> gateway = getGateway();
			Collection<Country> countries = gateway.getAll(Country.class);

			logger.info("Get all countries");		

			request.setAttribute("data", countries);
		
			logger.info("Set all countries into session");
			logger.info("Send redirect to showAll.jsp page");

			request.getRequestDispatcher("country/showAll.jsp").forward(request, response);
		}
		catch (Exception e) {
			try {	
				logger.error("Error  occured", e);
				logger.info("Send redirect to error page");
				//response.sendRedirect("/WebPrototype/error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {
				logger.error("Critical error was occured", ex);
			}
		}
	}
}