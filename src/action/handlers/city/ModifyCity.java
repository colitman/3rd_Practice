package action.handlers.city;

import logger.*;
import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ModifyCity implements HttpAction {

	private static final Logger logger = Logger.getLogger(ModifyCity.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to modify city");

			int id = Integer.valueOf(request.getParameter("id"));

			LoggerUtils.info(logger, "Get region id:", request.getParameter("id"));
		
			City city = new City();
			city.setID(id);
			city.setName(request.getParameter("name"));
			city.setPopulation(Integer.valueOf(request.getParameter("population")));
			city.setSquare(Integer.valueOf(request.getParameter("square")));
			city.setParentID(Integer.valueOf(request.getParameter("parent_id")));

			logger.info("New city properties: ");
			
			LoggerUtils.info(logger, "Name:", request.getParameter("name"));
			LoggerUtils.info(logger, "Population:", request.getParameter("population"));
			LoggerUtils.info(logger, "Square:", request.getParameter("square"));
			LoggerUtils.info(logger, "ParentID:", request.getParameter("parent_id"));
		
			GatewayResolver.getGateway().modify(city);
			
			logger.info("City was successfully modified");			
			logger.info("Send redirect to university/showAllCity page");

			response.sendRedirect("/WebPrototype/action?code=showAllUniversityInCity&parent_id=" + id);
		}
		catch (Exception e) {
			logger.error("Error occured in ModifyCity action", e);
		}
	}
}