package maths.Polynome;

public class Polynome {
    private double[] coeffs;

    public Polynome (double[] coeffs){
        // this.coeffs = coeffs; // ne fonctionne pas car si on a un tableau avec plein de 0 ça sera
        // rempli inutilement
        int maxNotNull = coeffs.length - 1;
        while((coeffs[maxNotNull] == 0) && (maxNotNull > 0)){
            maxNotNull -=1;
        }
        this.coeffs = new double[maxNotNull+1];
        for (int i = 0; i < this.coeffs.length; i++){
            this.coeffs[i] = coeffs[i];
        }
    }

    public int getDegre(){
        return (coeffs.length - 1);
    }

    public double get(int i){
        if (i < 0 || i > getDegre()){
            return 0;
        }
        return coeffs[i];
    }

    @Override
    public String toString(){
        String res = "";
        if (getDegre() > 0){
            res+= "+"+get(getDegre())+"x^"+getDegre();
        }
        else if (getDegre() < 0){
            res+= get(getDegre())+"x^"+getDegre();
        }
        for (int i = getDegre()-1; i > 0; i--){
            if (get(i) > 0){
                res+= "+"+get(i)+"x^"+i;
            }
            else if (get(i) < 0){
                res+= get(i)+"x^"+i;
            }
        }
        if (get(0) > 0){
            res+="+"+get(0);
        }
        else if (get(0) < 0){
            res+=get(0);
        }
        return res;
    }

    public boolean equals(Object o){
        if (o instanceof Polynome){
            Polynome p = (Polynome) o;
            if (this.getDegre() != p.getDegre()){
                return false;
            }
            for (int i = 0; i < getDegre(); i++){
                if (this.get(i) != p.get(i)){
                    return false;
                }
            }
            return true;
        }
        return false;
    }

    public double evals(double x){
        double sum = 0;
        for (int i = 0; i <= getDegre(); i++){
            sum += get(i) * Math.pow(x,i);
        }
        return sum;
    }

    public Polynome derive(){
        double[] der = new double[getDegre()];
        for (int i = 0; i < getDegre(); i++){
            der[i] = get(i+1)*(i+1);
        }
        return (new Polynome(der));
    }
}
