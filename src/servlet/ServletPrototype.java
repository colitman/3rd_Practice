package servlet;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ServletPrototype extends HttpServlet {
	
	@Override
	public void service(HttpServletRequest request, HttpServletResponse responce) {
		try {
			String code = request.getParameter("code");
			ActionFactory.getInstance().build(code).perform(request, responce);
		}
		catch (Exception e) {

		}
	}
}