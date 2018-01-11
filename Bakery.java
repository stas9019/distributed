public class Bakery extends Thread {

	public int pid;
	public static final int iterations = 200;
	public static final int numberOfThreads = 5;
	public static int count = 0;

	private static boolean[] entering = new boolean[numberOfThreads];
	private static int[] ticket = new int[numberOfThreads];

	public Bakery(int pid) {
		this.pid = pid;
	}

	public void run() {

		for (int i = 0; i < iterations; i++) {

			lock(pid);
            
				count = count + 1;
            
			unlock(pid);

		}

	}


	public void lock(int pid) {

		entering[pid] = true;

		ticket[pid] = findMax() + 1;
		entering[pid] = false;


		for (int i = 0; i < numberOfThreads; i++) {

			if (i == pid)
				continue;

            while (entering[i]) { Thread.yield(); }


            while (ticket[i] != 0 && (ticket[pid] > ticket[i] || (ticket[pid] == ticket[i] && pid > i))) {  Thread.yield();  }

		}
	}


	private void unlock(int id) {
		ticket[id] = 0;
	}


	private int findMax() {

		int max = ticket[0];

		for (int i = 1; i < ticket.length; i++) {
			if (ticket[i] > max)
				max = ticket[i];
		}
		return max;
	}

	public static void main(String[] args) {

		for (int i = 0; i < numberOfThreads; i++) {
			entering[i] = false;
			ticket[i] = 0;
		}

		Bakery[] threads = new Bakery[numberOfThreads];

		for (int i = 0; i < threads.length; i++) {
			threads[i] = new Bakery(i);
			threads[i].start();
		}

		for (int i = 0; i < threads.length; i++) {
			try {
				threads[i].join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		System.out.println("Result is " + count + ", expected " + (iterations * numberOfThreads));
	}

}
