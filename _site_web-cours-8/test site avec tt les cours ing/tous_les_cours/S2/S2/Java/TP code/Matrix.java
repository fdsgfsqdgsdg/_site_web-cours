public class Matrix {

	private double[][] coeffs;

	public Matrix(int nbRows, int nbColumns) {
		if (nbRows > 0 && nbColumns > 0) {
			this.coeffs = new double[nbRows][nbColumns];
			for (int i = 0; i < this.coeffs.length; i++) {
				for (int j = 0; j < this.coeffs[i].length; j++) {
					this.coeffs[i][j] = 0.0;
				}
			}
		} else {
			this.coeffs = new double[0][0];
		}
	}

	public Matrix(double[][] m) {
		this(m.length, m[0].length);
		for (int i = 0; i < m.length; i++) {
			for (int j = 0; i < m[i].length; j++) {
				this.coeffs[i][j] = m[i][j];
			}
		}
	}

	public int getNbRows() {
		return this.coeffs.length;
	}

	public int getNbColumns() {
		if (this.getNbRows() > 0) {
			return this.coeffs[0].length;
		} else {
			return 0;
		}
	}

	public double get(int row, int column) {
		if (row < 0 || row >= this.getNbRows() || column < 0
				|| column >= this.getNbColumns()) {
			return Double.POSITIVE_INFINITY;
		} else {
			return this.coeffs[row][column];
		}
	}

	public void set(int row, int column, double value) {
		if (row >= 0 && row < this.getNbRows() && column >= 0
				&& column < this.getNbColumns()) {
			this.coeffs[row][column] = value;
		}
	}

	public String toString() {
		String res = "";
		for (int i = 0; i < this.getNbRows(); i++) {
			for (int j = 0; j < this.getNbColumns(); j++) {
				res = res + this.get(i, j) + "\t";
			}
			res = res + "\n";
		}
		return res;
	}

	public static void main(String[] args) {
		Matrix m1 = new Matrix(2, 3);
		m1.set(0, 0, 1.1);
		m1.set(0, 1, 1.2);
		m1.set(0, 2, -1.3);
		m1.set(1, 0, -2.1);
		m1.set(1, 1, 2.2);
		m1.set(1, 2, 2.3);
		double[][] tab = { { 1.1, 1.2, -1.3 }, { -2.1, 2.2, 2.3 } };
		Matrix m2 = new Matrix(tab);
		System.out.println(m2);
	}
}