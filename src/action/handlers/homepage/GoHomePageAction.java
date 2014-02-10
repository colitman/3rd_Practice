package action.handlers.homepage;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class GoHomePageAction implements HttpAction {
	
	private static final Logger logger = Logger.getLogger("logger");

	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {	
			logger.info("Send redirect to homepage");
			response.sendRedirect("/WebPrototype/index.jsp");
		}
		catch (Exception e) {
			logger.error("Error occured in GoHomePage action", e);
		}
	}
}