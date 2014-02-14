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
			Region region = new Region();
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

			GatewayResolver.getGateway().modify(id, region);

			logger.info("Region was successfully modified");			
			logger.info("Send redirect to showAllRegion page");

			response.sendRedirect("/WebPrototype/region/showAll.jsp?success=true");
		}
		catch (Exception e) {
			logger.error("Error occured in ModifyRegion action", e);
		}
	}
}