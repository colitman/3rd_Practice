package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(ShowOneCity.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show city");

			Gateway<City> gateway = GatewayResolver.getGateway();
			int id = Integer.valueOf(request.getParameter("id"));
			City city = null;

			if (logger.isInfoEnabled()) {
				logger.info("City properties: ");
				logger.info("Name: " + city.getName());
				logger.info("Population: " + city.getPopulation());
				logger.info("Square: " + city.getSquare());
				logger.info("ParentID: " + city.getParentID());	
			}

			request.getSession().setAttribute("city", city);

			logger.info("Set city into session");
			logger.info("Send redirect to showAllCity page");
		
			response.sendRedirect("/WebPrototype/city/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			logger.error("Error occured in ShowOneCity action", e);
		}
	}
}