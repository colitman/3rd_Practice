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

public class ShowOneUniversity implements HttpAction {

	private static final Logger logger = Logger.getLogger(ShowOneUniversity.class);	
	
	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to show university");

			int id = Integer.valueOf(request.getParameter("parent_id"));

			Gateway<University> gateway = GatewayResolver.getGateway();
			University university = gateway.get(University.class, id);
	
			logger.info("University properties: ");
	
			LoggerUtils.info(logger, "Name:", university.getName());
			LoggerUtils.info(logger, "DepartamentsCount:", String.valueOf(university.getDepartamentsCount()));
			LoggerUtils.info(logger, "WWW:", university.getWWW());
			LoggerUtils.info(logger, "ParentID:", String.valueOf(university.getParentID()));	
            	
			GatewayResolver.unsetGateway();
            		Gateway<City> cityGateway = GatewayResolver.getGateway();
			City city = cityGateway.get(City.class, university.getParentID());
            
            		Gateway<Region> regionGateway = GatewayResolver.getGateway();
			Region region = regionGateway.get(Region.class, city.getParentID());
            
            		Gateway<Country> countryGateway = GatewayResolver.getGateway();
			Country country = countryGateway.get(Country.class, region.getParentID());
	
			request.setAttribute("parent", university);
            		request.setAttribute("city", city);
            		request.setAttribute("region", region);
            		request.setAttribute("country", country);

			logger.info("Set university into session");
			logger.info("Send forward to showAllUniversity page");	

			return "university/showOne.jsp";
		}
		catch (Exception e) {
			logger.error("Error occured in ShowOneUniversity action", e);
			throw new ActionException(e);
		}
	}
}