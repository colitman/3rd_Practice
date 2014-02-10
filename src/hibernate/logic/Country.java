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
    	@Column(name="ID", nullable=false)
	private int id;
	@Column(name="NAME", nullable=false)
	private String name;
	@Column(name="LANG", nullable=true)
	private String language;
	@Column(name="CAPITAL", nullable=true)
	private String capital;
	@Column(name="POPULATION", nullable=true)
	private Integer population;
	@Column(name="TIMEZONE", nullable=true)
	private Integer timezone;

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
}