package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class ModifyUniversity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		University university = null;
		int index = 0;
		if (args[1] instanceof University) {
			university = (University) args[1];
		}
		if (args[0] != null) {
			index = (int) args[0];
		}
		getGateway().modify(index, university);
	}
}