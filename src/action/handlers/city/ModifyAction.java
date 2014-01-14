package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public ModifyAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		City city = null;
		int index = 0;
		if (args[1] instanceof City) {
			city = (City) args[1];
		}
		if (args[0] != null) {
			index = args[0];
		}
		new OracleGateway<City>().modify(index, city);
	}
}