package action.handlers.region;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllRegion implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			response.sendRedirect("region/showAll.jsp");
		}
		catch (Exception e) {

		}
	}
}