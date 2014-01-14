package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public RemoveAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		University university = null;
		if (args[0] instanceof University) {
			university = (University) args[0];
		}
		new OracleGateway<University>().remove(university);
	}
}