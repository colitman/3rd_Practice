package action.handlers.country;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllCountry implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			response.sendRedirect("country/showAll.jsp");
		}
		catch (Exception e) {
			try {
				response.sendRedirect("error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {

			}
		}
	}
}