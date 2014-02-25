package action.handlers.university;

import logger.*;
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

public class ShowAllUniversityInCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ShowAllUniversityInCity.class);	

	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to show all universities");

			int parentID = Integer.valueOf(request.getParameter("parent_id"));

			LoggerUtils.info(logger, "Get parent id:", request.getParameter("parent_id"));

			Gateway<City> parentGateway = GatewayResolver.getGateway();
			City parent = parentGateway.get(City.class, parentID);

			logger.info("Get parent object");
            
			if (parent != null) {
				GatewayResolver.unsetGateway();
        	    		Gateway<Region> regionGateway = GatewayResolver.getGateway();
            			Region region = regionGateway.get(Region.class, parent.getParentID());
            			logger.info("Get region object");
            
            			Gateway<Country> countryGateway = GatewayResolver.getGateway();
            			Country country = countryGateway.get(Country.class, region.getParentID());
            			logger.info("Get country object");

				request.setAttribute("region", region);
            			request.setAttribute("country", country);
			}

			Gateway<University> gateway = GatewayResolver.getGateway();
			Collection<University> data = gateway.getAllBy(University.class, parentID);
		
			logger.info("Get all universities");

			request.setAttribute("data", data);
	
			logger.info("Set universities into request attributes");

			request.setAttribute("parent", parent);
            		
			logger.info("Set parent object into request attributes");
			logger.info("Send forward to university/showAllInCity.jsp page");

			return "university/showAllInCity.jsp";
		}
		catch (Exception e) {
			logger.error("Error  occured in ShowAllUniversityInCity action", e);
			throw new ActionException(e);
		}
	}
}