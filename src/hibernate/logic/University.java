package hibernate.logic;

import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="University")
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
	
	@Column(name="parent_id")
	public int getParentID() {
		return parentID;
	}

	public void setID(int id) {
		this.id = id;
	}	

	@Id
    	@GeneratedValue(generator="increment")
    	@GenericGenerator(name="increment", strategy = "increment")
    	@Column(name="id")
	public int getID() {
		return id;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name="name")
	public String getName() {
		return name;
	}

	public void setDepartamentsCount(int count) {
		departamentsCount = count;
	}

	@Column(name="depts_count")
	public int getDepartamentsCount() {
		return departamentsCount;
	}

	public void setWWW(String www) {
		this.www = www;
	}

	@Column(name="www")
	public String getWWW() {
		return www;
	}
}