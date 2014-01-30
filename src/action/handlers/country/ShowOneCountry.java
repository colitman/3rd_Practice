package action.handlers.country;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import org.apache.log4j.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneCountry implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");	

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			logger.info("Prepare to show country");

			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<Country> gateway = (Gateway) context.getBean("oracleGateway");
			int id = Integer.valueOf(request.getParameter("id"));
			Country country = gateway.get(id);
	
			logger.info("Country properties: ");
			logger.info("Name: " + country.getName());
			logger.info("Language: " + country.getLanguage());
			logger.info("Capital: " + country.getCapital());
			logger.info("Population: " + country.getPopulation());
			logger.info("Timezone: " + country.getTimezone());

			request.getSession().setAttribute("country", country);

			logger.info("Set country into session");
			logger.info("Send redirect to showAllCountry page");

			response.sendRedirect("/WebPrototype/country/showOne.jsp?id=" + id);
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