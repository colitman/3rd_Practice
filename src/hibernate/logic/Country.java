package hibernate.logic;

import java.util.*;
import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="COUNTRY")
public class Country {

	@Id
    	@GeneratedValue(generator="increment")
    	@GenericGenerator(name="increment", strategy = "increment")
    	@Column(name="ID")
	private int id;
	@Column(name="NAME")
	private String name;
	@Column(name="LANG")
	private String language;
	@Column(name="CAPITAL")
	private String capital;
	@Column(name="POPULATION")
	private Integer population;
	@Column(name="TIMEZONE")
	private Integer timezone;
	//private Set<Region> regions;

	public Country() {

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

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getLanguage() {
		return language;
	}
	
	public void setCapital(String capital) {
		this.capital = capital;
	}

	public String getCapital() {
		return capital;
	}

	public void setPopulation(int population) {
		this.population = population;
	}

	public int getPopulation() {
		return population;
	}

	public void setTimezone(int timezone) {
		this.timezone = timezone;
	}

	public int getTimezone() {
		return timezone;
	}

	/*
	public void setRegions(Set<Region> regions) {
		this.regions = regions;
	}
	
	public Set<Region> getRegions() {
		return regions;
	}
	*/
}