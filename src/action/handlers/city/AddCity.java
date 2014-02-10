package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class AddCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to add city");
			City city = new City();
			city.setName(request.getParameter("name"));
			city.setPopulation(Integer.valueOf(request.getParameter("population")));
			city.setSquare(Integer.valueOf(request.getParameter("square")));
			city.setParentID(Integer.valueOf(request.getParameter("parent_id")));
	
			logger.info("City properties: ");
			logger.info("Name: " + request.getParameter("name"));
			logger.info("Population: " + request.getParameter("population"));
			logger.info("Square: " + request.getParameter("square"));
			logger.info("ParentID: " + request.getParameter("parent_id"));
				
			GatewayResolver.getGateway().add(city);
	
			logger.info("City was successfully added");			
			logger.info("Send redirect to showAllCity page");
			response.sendRedirect("/WebPrototype/action?code=showAllCityInRegion&parent_id=" + request.getParameter("parent_id"));
		}
		catch (Exception e) {
			logger.error("Error occured in AddCity action", e);
		}
	}
}