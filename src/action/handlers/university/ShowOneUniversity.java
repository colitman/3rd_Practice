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

public class ShowOneUniversity extends GatewayAction {

	private static final Logger logger = Logger.getLogger("logger");	
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show university");

			Gateway<University> gateway = getGateway();
			int id = Integer.valueOf(request.getParameter("id"));
			University university = null;
	
			logger.info("University properties: ");
			logger.info("Name: " + university.getName());
			logger.info("DepartamentsCount: " + university.getDepartamentsCount());
			logger.info("WWW: " + university.getWWW());
			logger.info("ParentID: " + university.getParentID());	

			request.getSession().setAttribute("university", university);

			logger.info("Set university into session");
			logger.info("Send redirect to showAllUniversity page");	

			response.sendRedirect("/WebPrototype/university/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			logger.error("Error occured in ShowOneUniversity action", e);
		}
	}
}