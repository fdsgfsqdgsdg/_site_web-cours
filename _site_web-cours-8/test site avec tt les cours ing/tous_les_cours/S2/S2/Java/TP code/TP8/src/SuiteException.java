public class SuiteException extends Exception {
    private String trace;
    public SuiteException(String msg) {
        super(msg);
        trace = "\n";
    }
    public void ajouterTrace(String s) {
        this.trace += s+"\n";
    }
    @Override
    public String toString() {
        return super.toString()+trace;
    }
}
