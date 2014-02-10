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

public class ShowAllUniversity implements HttpAction {

	private static final Logger logger = Logger.getLogger("logger");	
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all universities");

			Gateway<University> gateway = GatewayResolver.getGateway();
			Collection<University> universities = gateway.getAll(University.class);
	
			logger.info("Get all universities");	

			request.getSession().setAttribute("universities", universities);

			logger.info("Set all universities into session");
			logger.info("Send redirect to showAllUniversity page");	

			response.sendRedirect("/WebPrototype/university/showAll.jsp");
		}
		catch (Exception e) {
			logger.error("Error occured in ShowAllCountry action", e);
		}	
	}
}