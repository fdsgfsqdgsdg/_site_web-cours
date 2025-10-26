package shape;

public class Circle implements Shape {

	private double radius;

	public Circle(double radius) {
		this.radius = radius;
	}

	public Circle() {
		this(1.0);
	}

	public double getRadius() {
		return this.radius;
	}

	public void setRadius(double radius) {
		this.radius = radius;
	}

	@Override
	public double area() {
		double radius = getRadius();
		return Math.PI * radius * radius;
	}

	@Override
	public boolean isBigger(Shape shape) {
		return this.area() > shape.area();
	}

	@Override
	public String toString() {
		return "cercle de rayon " + this.getRadius();
	}

}
