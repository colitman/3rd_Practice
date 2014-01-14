package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public AddAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		University university = null;
		if (args[0] instanceof university) {
			university = (University) args[0];
		}
		new OracleGateway<University>().add(university);
	}
}