package servlet;

import action.*;
import java.servlet.*;
import java.servlet.http.*;

public class ServletPrototype extends HttpServlet {
	
	@Override
	public void service(HttpServletRequest request, HttpServletResponse responce) {
		
		String code = request.getParamater("code");
		ActionFactory.getInstance().build(code).perform(request, responce);
	}
}