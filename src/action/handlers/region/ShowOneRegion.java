package action.handlers.region;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show region");

			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<Region> gateway = (Gateway) context.getBean("oracleGateway");
			int id = Integer.valueOf(request.getParameter("id"));
			Region region = null;
	
			logger.info("Region properties: ");
			logger.info("Name: " + region.getName());
			logger.info("Population: " + region.getPopulation());
			logger.info("Square: " + region.getSquare());
			logger.info("ParentID: " + region.getParentID());	

			request.getSession().setAttribute("region", region);
	
			logger.info("Set region into session");
			logger.info("Send redirect to showAllRegion page");

			response.sendRedirect("/WebPrototype/region/showOne.jsp?id=" + id);
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