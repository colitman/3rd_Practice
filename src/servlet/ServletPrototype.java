package servlet;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ServletPrototype extends HttpServlet {
	
	private static final Logger logger = Logger.getLogger(ServletPrototype.class);	

	@Override
	public void service(HttpServletRequest request, HttpServletResponse responce) {
		try {
			if (logger.isInfoEnabled()) {
				logger.info("Building HttpAction");
				logger.info("Code: " + request.getParameter("code"));
			}

			String code = request.getParameter("code");
			ActionFactory.getInstance().build(code).perform(request, responce);
		}
		catch (Exception e) {
			logger.error("Error occured in ServletPrototype", e);
		}
	}
}