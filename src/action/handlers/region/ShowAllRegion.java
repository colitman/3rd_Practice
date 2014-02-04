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

public class ShowAllRegion extends GatewayAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show all regions");

			OracleEntity parent = (OracleEntity) request.getAttribute("parent");

			logger.info("Get parent");

			Gateway<Region> gateway = (Gateway<Region>) getGateway();
			Collection<Region> regions = gateway.getAllBy(Region.class, parent);
		
			logger.info("Get all regions");		

			request.getSession().setAttribute("regions", regions);

			logger.info("Set all regions into session");
			logger.info("Send redirect to showAllRegion page");	

			request.getRequestDispatcher("region/showAll.jsp");
		}
		catch (Exception e) {
			logger.error("Error occured in ShowAllRegion action", e);
		}
	}
}