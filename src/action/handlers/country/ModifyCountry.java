package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ModifyCountry extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to modify country");

			int id = Integer.valueOf(request.getParameter("id"));
			Country country = new Country();
			country.setName(request.getParameter("name"));
			country.setLanguage(request.getParameter("language"));
			country.setCapital(request.getParameter("capital"));
			country.setPopulation(Integer.valueOf(request.getParameter("population")));
			country.setTimezone(Integer.valueOf(request.getParameter("timezone")));

			logger.info("New country properties: ");
			logger.info("Name: " + request.getParameter("name"));
			logger.info("Language: " + request.getParameter("language"));
			logger.info("Capital: " + request.getParameter("capital"));
			logger.info("Population: " + request.getParameter("population"));
			logger.info("Timezone: " + request.getParameter("timezone"));

			getGateway().modify(id, country);

			logger.info("Country was successfully modified");			
			logger.info("Send redirect to showAllCountry page");
		
			response.sendRedirect("/WebPrototype/country/showAll.jsp?success=true");
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