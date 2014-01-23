package hibernate.logic;

import java.util.*;
import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="City")
public class City {

	private int parentID;
	private int id;
	private String name;
	private int population;
	private int square;
	private Set<University> universities;

	public City() {

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

	public void setPopulation(int population) {
		this.population = population;
	}

	@Column(name="population")
	public int getPopulation() {
		return population;
	}

	public void setSquare(int square) {
		this.square = square;
	}

	@Column(name="square")
	public int getSquare() {
		return square;
	}

	public void setUniversities(Set<University> universities) {
		this.universities = universities;
	}

	public Set<University> getUniversities() {
		return universities;
	}
}