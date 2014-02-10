package action.handlers.university;

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
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all universities");

			int parentID = Integer.valueOf(request.getParameter("parent_id"));

			logger.info("Get parent id: " + parentID);

			Gateway<City> parentGateway = GatewayResolver.getGateway();
			City parent = parentGateway.get(City.class, parentID);

			logger.info("Get parent object");

			Gateway<University> gateway = GatewayResolver.getGateway();
			Collection<University> data = gateway.getAllBy(University.class, parentID);
		
			logger.info("Get all universities");

			request.setAttribute("data", data);
	
			logger.info("Set universities into request attributes");

			request.setAttribute("parent", parent);

			logger.info("Set parent object into request attributes");
			logger.info("Send forward to university/showAllInCity.jsp page");

			request.getRequestDispatcher("university/showAllInCity.jsp").forward(request, response);
		}
		catch (Exception e) {
			logger.error("Error  occured in ShowAllUniversityInCity action", e);
		}
	}
}