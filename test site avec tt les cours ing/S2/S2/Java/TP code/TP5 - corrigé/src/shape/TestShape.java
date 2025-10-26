package shape;

public class TestShape {

	public static void compare(Shape s1, Shape s2) {
		if (s1.isBigger(s2)) {
			System.out.println("Un " + s1 + " (aire = " + s1.area()
					+ ") est plus grand qu'un " + s2 + " (aire = " + s2.area()
					+ ").");
		} else {
			System.out.println("Un " + s1 + " (aire = " + s1.area()
					+ ") est plus petit qu'un " + s2 + " (aire = " + s2.area()
					+ ").");
		}
	}

	public static void main(String[] args) {
		Shape s1 = new Square(2);
		Shape s2 = new Square();
		Shape c1 = new Circle(2);
		Shape c2 = new Circle();
		compare(s1, s2);
		compare(s1, c1);
		compare(c2, s2);
		compare(c1, c2);
	}
}
