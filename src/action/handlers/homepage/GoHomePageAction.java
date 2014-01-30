package action.handlers.homepage;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;
import org.apache.log4j.xml.*;

public class GoHomePageAction implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			DOMConfigurator.configure("C:/Workspace/LAB3/Mego_Portal_XD/res/log4j.xml");
		
			logger.info("Send redirect to homepage");
			response.sendRedirect("/WebPrototype/index.jsp");
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