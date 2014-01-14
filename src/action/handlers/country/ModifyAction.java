package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public ModifyAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		Country country = null;
		int index = 0;
		if (args[1] instanceof Country) {
			country = (Country) args[1];
		}
		if (args[0] != null) {
			index = args[0];
		}
		new OracleGateway<Country>().modify(index, country);
	}
}