package action;

import java.sql.SQLException;

public interface Action {
	
	public void perform(Object... args) throws ActionException, SQLException;
}