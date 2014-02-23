package action.handlers.region;

import logger.*;
import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class AddRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(AddRegion.class);	

	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to add region");

			Region region = new Region();
			region.setName(request.getParameter("name"));
			region.setPopulation(Integer.valueOf(request.getParameter("population")));
			region.setSquare(Integer.valueOf(request.getParameter("square")));
			region.setParentID(Integer.valueOf(request.getParameter("parent_id")));
	
			logger.info("Region properties: ");

			LoggerUtils.info(logger, "Name:", request.getParameter("name"));
			LoggerUtils.info(logger, "Population:", request.getParameter("population"));
			LoggerUtils.info(logger, "Square:", request.getParameter("square"));
			LoggerUtils.info(logger, "ParentID:", request.getParameter("parent_id"));

			GatewayResolver.getGateway().add(region);

			logger.info("Region was successfully added");			
			logger.info("Send redirect to showAllRegion page");

			return "action?code=showAllRegionInCountry&parent_id=" + request.getParameter("parent_id");
		}
		catch (Exception e) {
			logger.error("Error occured in AddRegion action", e);
			throw new ActionException(e);
		}
	}
}