package action.handlers.city;

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

public class ShowAllCityInRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ShowAllCityInRegion.class);	

	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to show all cities");

			int parentID = Integer.valueOf(request.getParameter("parent_id"));
			
			LoggerUtils.info(logger, "Get parent id:", request.getParameter("parent_id"));

			Gateway<Region> parentGateway = GatewayResolver.getGateway();
			Region parent = parentGateway.get(Region.class, parentID);
            logger.info("Get parent object");
            
            Gateway<Country> countryGateway = GatewayResolver.getGateway();
            Country country = countryGateway.get(Country.class, parent.getParentID());
            logger.info("Get country object");

			Gateway<City> gateway = GatewayResolver.getGateway();
			Collection<City> data = gateway.getAllBy(City.class, parentID);
		
			logger.info("Get all cities");

			request.setAttribute("data", data);
	
			logger.info("Set cities into request attributes");

			request.setAttribute("parent", parent);
            request.setAttribute("country", country);

			logger.info("Set parent object into request attributes");
			logger.info("Send forward to city/showAllInRegion.jsp page");

			return "city/showAllInRegion.jsp";
		}
		catch (Exception e) {
			logger.error("Error  occured in ShowAllCityInRegion action", e);
			throw new ActionException(e);
		}
	}
}