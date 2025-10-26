package stack;

import shape.Shape;

public interface ShapeStack {

	boolean isEmpty();

	void push(Shape shape);

	void pop();

	Shape peek();

}
