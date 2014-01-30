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
import java.util.Collection;

public class ShowAllRegion implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all regions");

			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<Region> gateway = (Gateway<Region>) context.getBean("oracleGateway");
			Collection<Region> regions = gateway.getAll(Region.class);
		
			logger.info("Get all regions");		

			request.getSession().setAttribute("regions", regions);

			logger.info("Set all regions into session");
			logger.info("Send redirect to showAllRegion page");	

			response.sendRedirect("/WebPrototype/region/showAll.jsp");
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