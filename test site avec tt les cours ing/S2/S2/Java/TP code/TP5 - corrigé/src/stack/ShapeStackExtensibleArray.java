package stack;

import shape.Shape;

public class ShapeStackExtensibleArray implements ShapeStack {

	private static final int INITIAL_SIZE = 8;
	private Shape[] shapes;
	private int nbElements;

	public ShapeStackExtensibleArray(int size) {
		if (size < 0) {
			size = 0;
		}
		this.shapes = new Shape[size];
		this.nbElements = 0;
	}

	public ShapeStackExtensibleArray() {
		this(INITIAL_SIZE);
	}

	@Override
	public boolean isEmpty() {
		return this.nbElements == 0;
	}

	@Override
	public void push(Shape shape) {
		if (this.nbElements == this.shapes.length) {
			Shape[] tmp = new Shape[this.shapes.length * 2 + 1];
			for (int i = 0; i < this.shapes.length; i++) {
				tmp[i] = this.shapes[i];
			}
			this.shapes = tmp;
		}
		this.shapes[this.nbElements++] = shape;
	}

	@Override
	public void pop() {
		if (!this.isEmpty()) {
			// sinon le ramasse-miettes ne peut pas libérer la mémoire
			this.shapes[--this.nbElements] = null;
		}
	}

	@Override
	public Shape peek() {
		if (!this.isEmpty()) {
			return this.shapes[this.nbElements - 1];
		}
		return null;
	}

}
