/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author luca
 */
public class SocialGoalEntity extends AbstractGoalEntity {
    private ManyActorsEntity actors;

    public ManyActorsEntity getActors() {
        return actors;
    }

    public void setActors(ManyActorsEntity actors) {
        this.actors = actors;
    }

    @Override
    public String toString() {
        return "SocialGoalEntity{" + "actors=" + actors + '}';
    }
    
    public void addBelief(LinkedList belief_base) {
        String name = this.getName();
        String[] split = name.split("\\.");
        
        //System.out.println("name="+name+" split into "+split.length+" parts");
        String namespace;
        String goalname;
        if (split.length!=0) {
            namespace = split[0];
            goalname = split[ split.length-1 ];
        } else {
            namespace = name;
            goalname = name;
        }
        
        belief_base.add("social_goal("+goalname+")[pack("+namespace+")]");
        
        if (split.length>1) {
            String contribute_name = split[ split.length-2 ];
            belief_base.add("contribute("+goalname+","+contribute_name+")[pack("+namespace+")]");
        }
        
        this.actors.addBeliefForSocialGoal(belief_base,goalname);
        
        belief_base.add("triggering_condition("+goalname+", "+getTriggeringCondition().getId(goalname)+" )[pack("+namespace+")]");
        this.getTriggeringCondition().addBelief(belief_base,goalname,namespace);

        belief_base.add("final_state("+goalname+", "+getFinalState().getId(goalname)+" )[pack("+namespace+")]");
        this.getFinalState().addBelief(belief_base,goalname,namespace);
    }

    public String getPredicate() {
    	return "social_goal( condition("+getTriggeringCondition().getPredicate()+"), condition("+getFinalState().getPredicate()+") )";
    }
    
}
