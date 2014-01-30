package action.handlers.homepage;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class GoHomePageAction implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			response.sendRedirect("/WebPrototype/index.jsp");
		}
		catch (Exception e) {
			try {
				response.sendRedirect("/WebPrototype/error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {

			}
		}
	}
}