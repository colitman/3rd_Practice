package action.handlers.country;

import logger.*;
import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ModifyCountry implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ModifyCountry.class);	

	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to modify country");

			int id = Integer.valueOf(request.getParameter("id"));

			LoggerUtils.info(logger, "Get country id:", request.getParameter("id"));

			Country country = new Country();
			country.setID(id);
			country.setName(request.getParameter("name"));
			country.setLanguage(request.getParameter("language"));
			country.setCapital(request.getParameter("capital"));
			country.setPopulation(Integer.valueOf(request.getParameter("population")));
			country.setTimezone(Integer.valueOf(request.getParameter("timezone")));

			logger.info("New country properties: ");
			
			LoggerUtils.info(logger, "Name:", request.getParameter("name"));
			LoggerUtils.info(logger, "Language:", request.getParameter("language"));
			LoggerUtils.info(logger, "Capital:", request.getParameter("capital"));
			LoggerUtils.info(logger, "Population:", request.getParameter("population"));
			LoggerUtils.info(logger, "Timezone:", request.getParameter("timezone"));

			Gateway<Country> gateway = GatewayResolver.getGateway();
			gateway.modify(country);

			logger.info("Country was successfully modified");			
			logger.info("Send redirect to region/showAllInCountry page");
		
			return "action?code=showAllRegionInCountry&parent_id=" + id;
		}
		catch (Exception e) {
			logger.error("Error occured in ModifyCountry action", e);
			throw new ActionException(e);
		}
	}
}