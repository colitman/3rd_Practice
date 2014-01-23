package action.handlers.country;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowOneCountry implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			response.sendRedirect("country/showOne.jsp?id=" + id);
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