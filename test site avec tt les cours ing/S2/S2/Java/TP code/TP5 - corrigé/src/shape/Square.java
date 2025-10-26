package shape;

public class Square implements Shape {

	private double side;

	public Square(double side) {
		this.side = side;
	}

	public Square() {
		this(1.0);
	}

	public double getSide() {
		return this.side;
	}

	public void setSide(double side) {
		this.side = side;
	}

	@Override
	public double area() {
		double side = getSide();
		return side * side;
	}

	@Override
	public boolean isBigger(Shape shape) {
		return this.area() > shape.area();
	}

	@Override
	public String toString() {
		return "carré de côté " + this.getSide();
	}
}
