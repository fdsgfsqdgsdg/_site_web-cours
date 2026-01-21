public class Pair<X extends Comparable<X>,Y extends Comparable<Y>> implements Cloneable,Comparable<Pair<X,Y>> { // extends car class et implements pour les interfaces
    private X first;
    private Y second;
    public Pair(X first, Y second){
        this.first = first;
        this.second = second;
    }
    public X getFirst() {
        return first;
    }
    public Y getSecond() {
        return second;
    }
    public void setFirst(X first) {
        this.first = first;
    }
    public void setSecond(Y second) {
        this.second = second;
    }
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Pair<?,?>){
            Pair<?,?> pair = (Pair<?,?>) obj;
            return this.getFirst().equals(pair.getFirst()) && this.getSecond().equals(pair.getSecond());
        }
        return false;
    }
    public String toString() {
        return "("+getFirst()+", "+getSecond()+")";
    }
    public Object clone() throws CloneNotSupportedException {
        return new Pair<X,Y>(this.getFirst(),this.getSecond());
    }
    public static <T extends Comparable<T>> T max(Pair<T,T> pair) {
        if (pair.getFirst().compareTo(pair.getSecond()) > 0) {
            return pair.getFirst();
        } else {
            return pair.getSecond();
        }
    }

    @Override
    public int compareTo(Pair<X, Y> p) {
        if (this.getFirst().compareTo(p.getFirst()) > 0) {
            return 1;
        } else if (this.getFirst().compareTo(p.getFirst()) == 0) {
            if (this.getSecond().compareTo(p.getSecond()) > 0) {
                return 1;
            }
            return this.getSecond().compareTo(p.getSecond());
        }
        return -1;
    }
    public static <T extends Number&Comparable<T>,Z extends Number&Comparable<Z>> double somme(Pair<T,Z> p) {
        return p.getFirst().doubleValue()+p.getSecond().doubleValue();
    }
}
