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

public class ShowAllRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ShowAllRegion.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all regions");

			Integer parentID = (Integer) request.getAttribute("parent_id");

			logger.info("Get parent id: " + parentID);

			Gateway<Region> gateway = GatewayResolver.getGateway();
			Collection<Region> regions = gateway.getAllBy(Region.class, parentID);
		
			logger.info("Get all regions");		

			request.getSession().setAttribute("regions", regions);

			logger.info("Set all regions into session");
			logger.info("Send redirect to showAllRegion page");	

			request.getRequestDispatcher("region/showAll.jsp").forward(request, response);
		}
		catch (Exception e) {
			logger.error("Error occured in ShowAllRegion action", e);
		}
	}
}