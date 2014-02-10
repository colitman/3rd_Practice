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

public class ShowAllCountry implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			DOMConfigurator.configure("log4j.xml");
			logger.info("Logger installed");
			logger.info("Prepare to show all countries");

			Gateway<Country> gateway = GatewayResolver.getGateway();
			Collection<Country> data = gateway.getAll(Country.class);
		
			logger.info("Get all countries");

			request.setAttribute("data", data);
	
			logger.info("Set countries into request attributes");
			logger.info("Send forward to country/showAll.jsp page");

			request.getRequestDispatcher("country/showAll.jsp").forward(request, response);
		}
		catch (Exception e) {
			logger.error("Error  occured in ShowAllCountry action", e);
		}
	}
}