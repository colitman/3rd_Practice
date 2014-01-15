package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class ModifyRegion extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		Region region = null;
		int index = 0;
		if (args[1] instanceof Region) {
			region = (Region) args[1];
		}
		if (args[0] != null) {
			index = (int) args[0];
		}
		getGateway().modify(index, region);
	}
}