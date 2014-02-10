package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class AddUniversity implements HttpAction {

	private static final Logger logger = Logger.getLogger("logger");	
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to add university");

			University university = new University();
			university.setName(request.getParameter("name"));
			university.setDepartamentsCount(Integer.valueOf(request.getParameter("departs_count")));
			university.setWWW(request.getParameter("www"));
			university.setParentID(Integer.valueOf(request.getParameter("parent_id")));
		
			logger.info("University properties: ");
			logger.info("Name: " + request.getParameter("name"));
			logger.info("DepartamentsCount: " + request.getParameter("departs_count"));
			logger.info("WWW: " + request.getParameter("www"));
			logger.info("ParentID: " + request.getParameter("parent_id"));

			GatewayResolver.getGateway().add(university);
		
			logger.info("University was successfully added");			
			logger.info("Send redirect to showAllUniversity page");

			response.sendRedirect("/WebPrototype/action?code=showAllUniversityInCity&parent_id=" + request.getParameter("parent_id"));
		}
		catch (Exception e) {
			logger.warn("Error occured in AddUniversity action", e);
		}
	}
}