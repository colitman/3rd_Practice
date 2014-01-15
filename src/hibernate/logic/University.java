package hibernate.logic;

public class University {

	private int parentID;
	private int id;
	private String name;
	private int departamentsCount;
	private String www;

	public University() {

	}
	
	public void setParentID(int id) {
		parentID = id;
	} 

	public int getParentID() {
		return parentID;
	}

	public void setID(int id) {
		this.id = id;
	}	

	public int getID() {
		return id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setDepartamentsCount(int count) {
		departamentsCount = count;
	}

	public int getDepartamentsCount() {
		return departamentsCount;
	}

	public void setWWW(String www) {
		this.www = www;
	}

	public String getWWW() {
		return www;
	}
}