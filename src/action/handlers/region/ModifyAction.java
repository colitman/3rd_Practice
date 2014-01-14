package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public ModifyAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		Region region = null;
		int index = 0;
		if (args[1] instanceof Region) {
			region = (Region) args[1];
		}
		if (args[0] != null) {
			index = args[0];
		}
		new OracleGateway<Region>().modify(index, region);
	}
}