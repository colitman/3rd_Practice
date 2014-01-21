package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllCity implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			response.sendRedirect("city/showAll.jsp");
		}
		catch (Exception e) {

		}
	}
}