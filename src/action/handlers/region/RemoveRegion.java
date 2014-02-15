package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class RemoveRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(RemoveRegion.class);		

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			if (logger.isInfoEnabled()) {
				logger.info("Prepare to remove region");
				logger.info("Removing region id: " + request.getParameter("id"));
			}

			int parentID = Integer.valueOf(request.getParameter("parent_id"));
	
			if (logger.isInfoEnabled()) {
				logger.info("Get parent id: " + parentID);
			}

			Gateway gateway = GatewayResolver.getGateway();
			int id = Integer.valueOf(request.getParameter("id"));
			Region region = (Region) gateway.get(Region.class, id);
			gateway.remove(region);
	
			logger.info("Region was successfully removed");			
			logger.info("Send redirect to showAllRegion page");

			response.sendRedirect("/WebPrototype/action?code=showAllRegionInCountry&parent_id=" + parentID);
		}	
		catch (Exception e) {
			logger.error("Error occured in RemoveRegion action", e);
		}
	}
}