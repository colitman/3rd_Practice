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

public class ShowOneUniversity implements HttpAction {

	private static final Logger logger = Logger.getLogger(ShowOneUniversity.class);	
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show university");

			int id = Integer.valueOf(request.getParameter("parent_id"));

			Gateway<University> gateway = GatewayResolver.getGateway();
			University university = gateway.get(University.class, id);
	
			if (logger.isInfoEnabled()) {
				logger.info("University properties: ");
				logger.info("Name: " + university.getName());
				logger.info("DepartamentsCount: " + university.getDepartamentsCount());
				logger.info("WWW: " + university.getWWW());
				logger.info("ParentID: " + university.getParentID());	
			}

			request.setAttribute("parent", university);

			logger.info("Set university into session");
			logger.info("Send redirect to showAllUniversity page");	

			request.getRequestDispatcher("university/showOne.jsp").forward(request, response);
		}
		catch (Exception e) {
			logger.error("Error occured in ShowOneUniversity action", e);
		}
	}
}