package action.handlers.country;

import logger.*;
import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class AddCountry implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(AddCountry.class);

	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to add country");

			Country country = new Country();
			country.setName(request.getParameter("name"));
			country.setLanguage(request.getParameter("language"));
			country.setCapital(request.getParameter("capital"));
			country.setPopulation(Integer.valueOf(request.getParameter("population")));
			country.setTimezone(Integer.valueOf(request.getParameter("timezone")));

			logger.info("Country properties: ");

			LoggerUtils.info(logger, "Name:", request.getParameter("name"));
			LoggerUtils.info(logger, "Language:", request.getParameter("language"));
			LoggerUtils.info(logger, "Capital:", request.getParameter("capital"));
			LoggerUtils.info(logger, "Population:", request.getParameter("population"));
			LoggerUtils.info(logger, "Timezone:", request.getParameter("timezone"));

			GatewayResolver.getGateway().add(country);
			
			logger.info("Country was successfully added");			
			logger.info("Send forward to showAllCountry page");

			return "action?code=showAllCountry";
		} 	
		catch (Exception e) {
			logger.error("Error occured in AddCountry action", e);
		}	
		return null;
	}
}