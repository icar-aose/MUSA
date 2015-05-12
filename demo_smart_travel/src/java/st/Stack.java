// CArtAgO artifact code for project adaptive_workflow

package st;

import java.util.Comparator;
import java.util.TreeSet;

import cartago.*;

public class Stack extends Artifact {
	private TreeSet<StackItem> stack;
	
	public static void main(String [ ] args) {
		Stack stack = new Stack();
		stack.init();
		
		stack.insert("cs1", "evo1", 3);
		stack.insert("cs2", "evo2", 1);
		stack.insert("cs3", "evo3", 4);
		stack.insert("cs4", "evo4", 2);
		
		StackItem focus1 = stack.removeHigher();
		StackItem focus2 = stack.removeHigher();
		StackItem focus3 = stack.removeHigher();
		StackItem focus4 = stack.removeHigher();
		
		System.out.println(focus1.getCS());
		System.out.println(focus2.getCS());
		System.out.println(focus3.getCS());
		System.out.println(focus4.getCS());
		
	}
	
	void init() {
		stack=new TreeSet<StackItem>(new Comparator<StackItem>() {
			public int compare(StackItem arg0, StackItem arg1) {
				StackItem item0 = (StackItem) arg0;
				StackItem item1 = (StackItem) arg1;
				
				if (item0.score < item1.score) {
					return -1;
				}
				if (item0.score > item1.score) {
					return 1;
				}
				return 0;
			}
		});
	}
	
	@OPERATION void insertItem(String cs, String evo, double score) {
		insert(cs,evo,score);
	}

	@OPERATION void pickItem(OpFeedbackParam<StackItem> item) {
		StackItem higher = removeHigher();
		item.set(higher);
	}

	@OPERATION void stackSize(OpFeedbackParam<Integer> number) {
		int size = stack.size();
		
		number.set(new Integer(size));
	}

	
 	public void insert(String cs, String evo, double score) {
		StackItem item = new StackItem();
		item.setCS(cs);
		item.setEvo(evo);
		item.setScore(score);
		
		stack.add(item);
	}
	
	public StackItem removeHigher() {
		//System.out.println("size: "+stack.size());
		StackItem higher = stack.last();
		
		stack.remove( higher );
		
		//System.out.println("size: "+stack.size());

		return higher;
	}
	
	
	private class StackItem implements c4jason.ToProlog {
		private String cs;
		private String evo;
		private double score;
		
		public String getAsPrologStr() {
			return "item("+cs+","+evo+","+score+")";
		}

		public String getCS() {
			return cs;
		}

		public void setCS(String cs) {
			this.cs = cs;
		}

		public String getEvo() {
			return evo;
		}

		public void setEvo(String evo) {
			this.evo = evo;
		}

		public double getScore() {
			return score;
		}

		public void setScore(double score) {
			this.score = score;
		}


	}
}

