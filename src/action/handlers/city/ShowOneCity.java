package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowOneCity implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			response.sendRedirect("city/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			try {
				response.sendRedirect("error.jsp");
			}
			catch (Exception ex) {
				
			}
		}
	}
}