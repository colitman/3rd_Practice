package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class RemoveCity extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to remove city");
			logger.info("Removing city id: " + request.getParameter("id"));

			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = getGateway();
			City city = (City) gateway.get(id);
			getGateway().remove(city);

			logger.info("City was successfully removed");			
			logger.info("Send redirect to showAllCity page");

			response.sendRedirect("/WebPrototype/city/showAll.jsp?success=true");
		}
		catch (Exception e) {
			try {
				logger.warn("Error was occured");
				logger.info("Send redirect to error page");
				response.sendRedirect("/WebPrototype/error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {
				logger.error("Critical error was occured");
			}
		}
	}
}