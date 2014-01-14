package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public ModifyAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		University university = null;
		int index = 0;
		if (args[1] instanceof University) {
			university = (University) args[1];
		}
		if (args[0] != null) {
			index = args[0];
		}
		new OracleGateway<University>().modify(index, university);
	}
}