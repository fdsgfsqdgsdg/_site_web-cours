import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class MajoriteAbsolue {
    private Map<Vote, Integer> suffrages;
    private  boolean Clos;
    public MajoriteAbsolue (int nbVotants, Vote[] votes) {
        suffrages = new HashMap<Vote, Integer>();
        for (Vote v : votes) {
            suffrages.put(v, 0);
        }
        suffrages.put(Vote.BLANC, 0);
        suffrages.put(Vote.NUL, 0);
        this.Clos = false;
    }
    public Set<Vote> getVotesPossibles() {
        return suffrages.keySet();
    }
    public void ajouterVote (Vote v){
        if (this.Clos) {
            ScrutinClosException s = new ScrutinClosException("ScrutinClosException");
            throw s;
        }
        if (getVotesPossibles().contains(v)){ //containsKey
            int x = suffrages.get(v);
            suffrages.put(v, x + 1);
        }
        else {
            int x = suffrages.get(Vote.NUL);
            suffrages.put(Vote.NUL, x + 1);
        }
    }
}
