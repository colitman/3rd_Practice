package action;

public interface Action {
	
	public void perform(Object... args) throws ActionException;
}