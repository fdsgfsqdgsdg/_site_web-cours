package stack;

import shape.Circle;
import shape.Square;

public class TestShapeStack {

	public static void testShapeStack(ShapeStack stack) {
		System.out.println("Est vide ? : " + stack.isEmpty()); // true
		stack.push(new Circle());
		System.out.println("Sommet : " + stack.peek());
		System.out.println("Est vide ? : " + stack.isEmpty()); // false
		stack.push(new Square());
		System.out.println("Sommet : " + stack.peek());
		stack.push(new Circle());
		System.out.println("Sommet : " + stack.peek());
		stack.push(new Square()); // carré non empilé pour pile avec taille fixe
		// cercle pour pile avec taille fixe, carré pour pile avec taille
		// extensible
		System.out.println("Sommet : " + stack.peek());
		stack.pop();
		System.out.println("Sommet : " + stack.peek());
		stack.pop();
		System.out.println("Sommet : " + stack.peek());
		stack.pop();
		// true pour pile avec taille fixe, false pour pile avec taille
		// extensible
		System.out.println("Est vide ? : " + stack.isEmpty());
	}

	public static void main(String[] args) {
		System.out.println("Pile de formes avec tableau de taille fixe :");
		testShapeStack(new ShapeStackFixedSizeArray(3));
		System.out.println("Pile de formes avec tableau extensible :");
		testShapeStack(new ShapeStackExtensibleArray());
	}
}
