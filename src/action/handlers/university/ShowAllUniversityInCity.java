package action.handlers.university;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllUniversityInCity implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int parentID = Integer.valueOf(request.getParameter("parent_id"));
			response.sendRedirect("university/showAll.jsp?parent_id=" + parentID);
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