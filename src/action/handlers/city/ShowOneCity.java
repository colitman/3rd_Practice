package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneCity implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show city");

			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<City> gateway = (Gateway) context.getBean("oracleGateway");
			int id = Integer.valueOf(request.getParameter("id"));
			City city = gateway.get(id);

			logger.info("City properties: ");
			logger.info("Name: " + city.getName());
			logger.info("Population: " + city.getPopulation());
			logger.info("Square: " + city.getSquare());
			logger.info("ParentID: " + city.getParentID());	

			request.getSession().setAttribute("city", city);

			logger.info("Set city into session");
			logger.info("Send redirect to showAllCity page");
		
			response.sendRedirect("/WebPrototype/city/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			try {
				logger.warn("Error was occured");
				logger.info("Send redirect to error page");
				response.sendRedirect("/WebPrototype/error.jsp");
			}
			catch (Exception ex) {
				logger.error("Critical error was occured");
			}
		}
	}
}