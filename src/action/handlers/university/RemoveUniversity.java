package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class RemoveUniversity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger(RemoveUniversity.class);	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			if (logger.isInfoEnabled()) {
				logger.info("Prepare to remove university");
				logger.info("Removing university id: " + request.getParameter("id"));
			}

			int parentID = Integer.valueOf(request.getParameter("parent_id"));
	
			if (logger.isInfoEnabled()) {
				logger.info("Get parent id: " + parentID);
			}

			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = GatewayResolver.getGateway();
			University university = (University) gateway.get(University.class, id);
			gateway.remove(university);
				
			logger.info("University was successfully removed");			
			logger.info("Send redirect to showAllUniversity page");

			response.sendRedirect("/WebPrototype/action?code=showAllUniversityInCity&parent_id=" + parentID);
		}
		catch (Exception e) {
			logger.error("Error occured in RemoveUniversity action", e);
		}
	}
}