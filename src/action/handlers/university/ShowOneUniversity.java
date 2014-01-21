package action.handlers.university;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowOneUniversity implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			response.sendRedirect("university/showOne.jsp?id=" + id);
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