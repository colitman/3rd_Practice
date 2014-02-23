package action.handlers.university;

import logger.*;
import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.*;

public class ModifyUniversity implements HttpAction {

	private static final Logger logger = Logger.getLogger(ModifyUniversity.class);	
	
	public String perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		if (request == null || response == null) {
			throw new NullPointerException();
		}
		try {
			logger.info("Prepare to modify university");

			int id = Integer.valueOf(request.getParameter("id"));
			
			LoggerUtils.info(logger, "Get region id:", request.getParameter("id"));
			
			University university = new University();
			university.setID(id);
			university.setName(request.getParameter("name"));
			university.setDepartamentsCount(Integer.valueOf(request.getParameter("departs_count")));
			university.setWWW(request.getParameter("www"));
			university.setParentID(Integer.valueOf(request.getParameter("parent_id")));	
		
			logger.info("New university properties: ");
		
			LoggerUtils.info(logger, "Name:", request.getParameter("name"));
			LoggerUtils.info(logger, "DepartamentsCount:", request.getParameter("departs_count"));
			LoggerUtils.info(logger, "WWW:", request.getParameter("www"));
			LoggerUtils.info(logger, "ParentID:", request.getParameter("parent_id"));
		
			GatewayResolver.getGateway().modify(university);

			logger.info("University was successfully modified");			
			logger.info("Send redirect to university/showOne page");

			return "action?code=showOneUniversity&parent_id=" + university.getID();
		}
		catch (Exception e) {
			logger.error("Error occured in ModifyUniversity action", e);
			throw new ActionException(e);
		}
	}
}