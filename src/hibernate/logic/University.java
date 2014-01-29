package hibernate.logic;

import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="UNIVERSITY")
public class University {

	@Column(name="PARENT_ID")
	private int parentID;
	@Id
    	@GeneratedValue(generator="increment")
    	@GenericGenerator(name="increment", strategy = "increment")
    	@Column(name="ID")
	private int id;
	@Column(name="NAME")
	private String name;
	@Column(name="DEPS_COUNT")
	private int departamentsCount;	
	@Column(name="WWW")
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