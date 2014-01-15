package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class ModifyCountry extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		Country country = null;
		int index = 0;
		if (args[1] instanceof Country) {
			country = (Country) args[1];
		}
		if (args[0] != null) {
			index = (int) args[0];
		}
		getGateway().modify(index, country);
	}
}