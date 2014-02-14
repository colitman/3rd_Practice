package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ModifyRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ModifyRegion.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to modify region");

			int id = Integer.valueOf(request.getParameter("id"));

			if (logger.isInfoEnabled()) {
				logger.info("Get region id: " + id);
			}

			Region region = new Region();
			region.setID(id);
			region.setName(request.getParameter("name"));
			region.setPopulation(Integer.valueOf(request.getParameter("population")));
			region.setSquare(Integer.valueOf(request.getParameter("square")));
			region.setParentID(Integer.valueOf(request.getParameter("parent_id")));			

			if (logger.isInfoEnabled()) {
				logger.info("New region properties: ");
				logger.info("Name: " + request.getParameter("name"));
				logger.info("Population: " + request.getParameter("population"));
				logger.info("Square: " + request.getParameter("square"));
				logger.info("ParentID: " + request.getParameter("parent_id"));
			}

			Gateway<Region> gateway = GatewayResolver.getGateway();
			gateway.modify(region);

			logger.info("Region was successfully modified");			
			logger.info("Send redirect to city/showAllInRegion page");

			response.sendRedirect("/WebPrototype/action?code=showAllCityInRegion&parent_id=" + id);
		}
		catch (Exception e) {
			logger.error("Error occured in ModifyRegion action", e);
		}
	}
}