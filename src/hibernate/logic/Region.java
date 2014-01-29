package hibernate.logic;

import java.util.*;
import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="REGION")
public class Region {

	@Column(name="PARENT_ID")
	private int parentID;
	@Id
    	@GeneratedValue(generator="increment")
    	@GenericGenerator(name="increment", strategy = "increment")
    	@Column(name="ID")
	private int id;
	@Column(name="NAME")
	private String name;
	@Column(name="POPULATION")
	private int population;
	@Column(name="SQUARE")
	private int square;
	//private Set<City> cities;

	public Region() {

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

	public void setPopulation(int population) {
		this.population = population;
	}

	public int getPopulation() {
		return population;
	}

	public void setSquare(int square) {
		this.square = square;
	}

	public int getSquare() {
		return square;
	}

	/*
	public void setCities(Set<City> cities) {
		this.cities = cities;
	}
	
	public Set<City> getCities() {
		return cities;
	}
	*/
}