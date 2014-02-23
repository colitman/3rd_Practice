package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.*;

public class Utils {
	
	public static String perform(String action, HttpServletRequest request, HttpServletResponse response) throws WrongCommandException, ActionException {
		return ActionFactory.getInstance().build(action).perform(request, response);
	}
}