package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class ModifyCity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		City city = null;
		int index = 0;
		if (args[1] instanceof City) {
			city = (City) args[1];
		}
		if (args[0] != null) {
			index = (int) args[0];
		}
		getGateway().modify(index, city);
	}
}