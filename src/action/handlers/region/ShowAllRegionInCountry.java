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
import java.util.Collection;

public class ShowAllRegionInCountry extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all regions");

			int parentID = Integer.valueOf(request.getParameter("parent_id"));

			logger.info("Get parent id: " + parentID);

			Gateway<Country> gateway = getGateway();
			Collection<Country> data = gateway.getAllBy(Region.class, parentID);
		
			logger.info("Get all regions");

			request.setAttribute("data", data);
	
			logger.info("Set regions into request attributes");
			logger.info("Send forward to region/showAllInCountry.jsp page");

			request.getRequestDispatcher("region/showAllInCountry.jsp").forward(request, response);
		}
		catch (Exception e) {
			logger.error("Error  occured in ShowAllRegionInCountry action", e);
		}
	}
}