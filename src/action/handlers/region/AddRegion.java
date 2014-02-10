package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class AddRegion extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to add region");

			Region region = new Region();
			region.setName(request.getParameter("name"));
			region.setPopulation(Integer.valueOf(request.getParameter("population")));
			region.setSquare(Integer.valueOf(request.getParameter("square")));
			region.setParentID(Integer.valueOf(request.getParameter("parent_id")));
		
			logger.info("Region properties: ");
			logger.info("Name: " + request.getParameter("name"));
			logger.info("Population: " + request.getParameter("population"));
			logger.info("Square: " + request.getParameter("square"));
			logger.info("ParentID: " + request.getParameter("parent_id"));

			getGateway().add(region);

			logger.info("Region was successfully added");			
			logger.info("Send redirect to showAllRegion page");

			response.sendRedirect("/WebPrototype/action?code=showAllRegionInCountry");
		}
		catch (Exception e) {
			logger.error("Error occured in AddRegion action", e);
		}
	}
}