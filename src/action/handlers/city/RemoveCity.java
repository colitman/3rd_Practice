package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class RemoveCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(RemoveCity.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			if (logger.isInfoEnabled()) {				
				logger.info("Prepare to remove city");
				logger.info("Removing city id: " + request.getParameter("id"));
			}
	
			int parentID = Integer.valueOf(request.getParameter("parent_id"));
	
			if (logger.isInfoEnabled()) {
				logger.info("Get parent id: " + parentID);
			}

			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = GatewayResolver.getGateway();
			City city = (City) gateway.get(City.class, id);
			GatewayResolver.getGateway().remove(city);

			logger.info("City was successfully removed");			
			logger.info("Send redirect to showAllCity page");

			response.sendRedirect("/WebPrototype/action?code=showAllCityInRegion&parent_id=" + parentID);
		}
		catch (Exception e) {
			logger.error("Error occured in RemoveCity action", e);
		}
	}
}