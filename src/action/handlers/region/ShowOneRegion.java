package action.handlers.region;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ShowOneRegion.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show region");

			Gateway<Region> gateway = GatewayResolver.getGateway();
			int id = Integer.valueOf(request.getParameter("id"));
			Region region = null;
	
			if (logger.isInfoEnabled()) {
				logger.info("Region properties: ");
				logger.info("Name: " + region.getName());
				logger.info("Population: " + region.getPopulation());
				logger.info("Square: " + region.getSquare());
				logger.info("ParentID: " + region.getParentID());
			}	

			request.getSession().setAttribute("region", region);
	
			logger.info("Set region into session");
			logger.info("Send redirect to showAllRegion page");

			response.sendRedirect("/WebPrototype/region/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			logger.error("Error occured in ShowOneRegion action", e);
		}	
	}
}